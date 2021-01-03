#using scripts\codescripts\struct;

#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_utils;

#using scripts\zm\_bb;
#using scripts\zm\_challenges;
#using scripts\zm\_util;

#namespace globallogic_score;

function updateMatchBonusScores( winner )
{
	/*if ( !game["timepassed"] )
		return;

	if ( !level.rankedMatch )
		return;

	// dont give the bonus until the game is over
	if ( level.teamBased && isdefined( winner ) )
	{
		if ( winner == "endregulation" )
			return;
		}

	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;		
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
				player thread _rank::endGameUpdate();
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
				
			spm = player _rank::getSPM();				
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isdefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isdefined(player.pers["team"] ) && player.pers["team"] != "spectator" )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
	else
	{
		if ( isdefined( winner ) )
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
				player thread _rank::endGameUpdate();
				continue;
			}
			
			totalTimePlayed = player.timePlayed["total"];
			
			// make sure the players total time played is no 
			// longer then the game length to prevent exploits
			if ( totalTimePlayed > gameLength )
			{
				totalTimePlayed = gameLength;
			}
			
		//	spm = player _rank::getSPM();

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
	}*/
}


function giveMatchBonus( scoreType, score )
{
	/*self endon ( "disconnect" );

	level waittill ( "give_match_bonus" );
	
	self AddRankXPValue( scoreType, score );
	
	self _rank::endGameUpdate();*/
}

function getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{
		if ( !isdefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isdefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}
	
	if ( tie || !isdefined( winner ) )
		return undefined;
	else
		return winner;
}

function resetScoreChain()
{
	self notify( "reset_score_chain" );
	
	//self LUINotifyEvent( &"score_event", 3, 0, 0, 0 );
	self.scoreChain = 0;
	self.rankUpdateTotal = 0;
}

function scoreChainTimer()
{
	self notify( "score_chain_timer" );
	self endon( "reset_score_chain" );
	self endon( "score_chain_timer" );
	self endon( "death" );
	self endon( "disconnect" );
	
	wait 20;
	
	self thread resetScoreChain();
}

function roundToNearestFive( score )
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

function givePlayerMomentumNotification( score, label, descValue, countsTowardRampage )
{
	rampageBonus = 0;
	if ( isdefined( level.usingRampage ) && level.usingRampage )
	{
		if ( countsTowardRampage )
		{
			if ( !isdefined( self.scoreChain ) )
			{
				self.scoreChain = 0;
			}
			self.scoreChain++;
			self thread scoreChainTimer();
		}
		if ( isdefined( self.scoreChain ) && ( self.scoreChain >= 999 ) )
		{
			rampageBonus = roundToNearestFive( int( score * level.rampageBonusScale + 0.5 ) );
		}
	}

	combat_efficiency_factor = 0;
	
	if ( score != 0 ) 
	{
		self LUINotifyEvent( &"score_event", 4, label, score, rampageBonus, combat_efficiency_factor );
	}

	score = score + rampageBonus;
	
	if ( ( score > 0 ) && self HasPerk( "specialty_earnmoremomentum" ) ) 
	{ 
		score = roundToNearestFive( int( score * GetDvarFloat( "perk_killstreakMomentumMultiplier" ) + 0.5 ) ); 
	} 
	
	_setPlayerMomentum( self, self.pers["momentum"] + score );
}

function resetPlayerMomentumOnDeath()
{
	if ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
	{
		_setPlayerMomentum( self, 0 );
		self thread resetScoreChain();
	}
}

function givePlayerMomentum( event, player, victim, descValue )
{
	/*if( isdefined(level.disableMomentum) && (level.disableMomentum==true) )
		return;
	
	score = _rank::getScoreInfoValue( event );
	assert( isdefined( score ) );
	label = _rank::getScoreInfoLabel( event );
	countsTowardRampage = _rank::doesScoreInfoCountTowardRampage( event );

	if ( event == "death" )
	{
		_setPlayerMomentum( victim, victim.pers["momentum"] + score );
	}
		
	if ( score == 0 )
	{
		return;
	}
	
	if ( !isdefined( label ) )
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
	
	player notify( "momentum_popup" );*/
}

function givePlayerScore( event, player, victim, descValue )
{
	scoreDiff = 0;
	momentum = player.pers["momentum"];
	givePlayerMomentum( event, player, victim, descValue );
	newMomentum = player.pers["momentum"];

	if ( level.overridePlayerScore )
		return 0;

	pixbeginevent("level.onPlayerScore");
	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );
	newScore = player.pers["score"];	
	pixendevent();

	// Removed a blackbox print for "mpplayerscore" from here
	player bb::add_to_stat( "score", newScore - score );

	if ( score == newScore )
		return 0;
		
	pixbeginevent("givePlayerScore");
	recordPlayerStats( player, "score", newScore );
	
	scoreDiff = (newScore - score);

	player AddPlayerStatWithGameType( "score", scoreDiff );
	if ( isdefined( player.pers["lastHighestScore"] ) && newScore > player.pers["lastHighestScore"] )
	{
		player setDStat( "HighestStats", "highest_score", newScore );
	}

//	player _persistence::addRecentStat( false, 0, "score", scoreDiff );

	pixendevent();
	return scoreDiff;
}

function default_onPlayerScore( event, player, victim )
{
	/*score = _rank::getScoreInfoValue( event );

	assert( isdefined( score ) );
	
	if ( level.wagerMatch )
	{
		player thread _rank::updateRankScoreHUD( score );
	}
	
	_setPlayerScore( player, player.pers["score"] + score );*/
}


function _setPlayerScore( player, score )
{
	/*if ( score == player.pers["score"] )
		return;

	if ( !level.rankedMatch )
	{
		player thread _rank::updateRankScoreHUD( score - player.pers["score"] );
	}

	player.pers["score"] = score;
	player.score = player.pers["score"];
	recordPlayerStats( player, "score" , player.pers["score"] );

	player notify ( "update_playerscore_hud" );
//	if ( level.wagerMatch )
//		player thread _wager::playerScored();
	player thread globallogic::checkScoreLimit();
	player thread globallogic::checkPlayerScoreLimitSoon();*/
}


function _getPlayerScore( player )
{
	return player.pers["score"];
}




function _setPlayerMomentum( player, momentum )
{
	momentum = math::clamp( momentum, 0, 2000 );

	oldMomentum = player.pers["momentum"];
	if ( momentum == oldMomentum )
		return;
	
	player bb::add_to_stat( "momentum", ( momentum - oldMomentum ));

	if ( momentum > oldMomentum )
	{
		highestMomentumCost = 0;
		numKillstreaks = player.killstreak.size;
		killStreakTypeArray = [];
		
		/*for ( currentKillstreak = 0 ; currentKillstreak < numKillstreaks ; currentKillstreak++ )
		{	
			killstreakType = _killstreaks::getKillstreakByMenuName( player.killstreak[ currentKillstreak ] );
			if ( isdefined( killstreakType ) )
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
		}*/
	}
		
	player.pers["momentum"] = momentum;
	player.momentum = player.pers["momentum"];
}

function _givePlayerKillstreakInternal( player, momentum, oldMomentum, killStreakTypeArray )
{
	/*for ( killstreakTypeIndex = 0 ; killstreakTypeIndex < killStreakTypeArray.size; killstreakTypeIndex++ )
	{
		killstreakType = killStreakTypeArray[killstreakTypeIndex];
		
		momentumCost = level.killstreaks[killstreakType].momentumCost;
		if ( momentumCost > oldMomentum && momentumCost <= momentum )
		{
			
			weapon = _killstreaks::getKillstreakWeapon( killstreakType );
			if ( IS_TRUE( level.usingScoreStreaks ) )
			{
				if( _killstreak_weapons::isHeldKillstreakWeapon( weapon ) )
				{
					if( !isdefined( player.pers["held_killstreak_ammo_count"][weapon] ) )
						player.pers["held_killstreak_ammo_count"][weapon] = 0;
				
					player.pers["held_killstreak_ammo_count"][weapon] = weapon.maxAmmo;
					player _class::setWeaponAmmoOverall( weapon, player.pers["held_killstreak_ammo_count"][weapon] );
				}
				else
				{
					player _killstreaks::changeKillstreakQuantity( weapon, 1 );
				}

				player _killstreaks::addKillstreakToQueue( level.killstreaks[killstreakType].menuname, 0, killstreakType );
			}
			else
			{
				player _killstreaks::addKillstreakToQueue( level.killstreaks[killstreakType].menuname, 0, killstreakType );
				activeEventName = "reward_active";
				if ( isdefined( weapon ) )
				{
					newEventName = weapon.name + "_active";
					if ( _scoreevents::isRegisteredEvent( newEventName ) )
					{
						activeEventName = newEventName;
					}
				}
			}
		}
	}*/
}

/#
function setPlayerMomentumDebug()
{
	SetDvar( "sv_momentumPercent", 0.0 );
	
	while( true )
	{
		wait( 1 );
		momentumPercent = GetDvarFloat( "sv_momentumPercent", 0.0 );
		if ( momentumPercent != 0.0 )
		{
			player = util::getHostPlayer();
			if ( !isdefined( player ) ) 
			{
				return;
			}
			if ( isdefined( player.killstreak ) )
			{
				_setPlayerMomentum( player,  int( 2000 * ( momentumPercent / 100 ) ) );
			}
		}
	}
}
#/

function giveTeamScore( event, team, player, victim )
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

	thread globallogic::checkScoreLimit();
}

function giveTeamScoreForObjective( team, score )
{
	teamScore = game["teamScores"][team];

	onTeamScore( score, team );

	newScore = game["teamScores"][team];
	
	// Removed a blackbox print for "mpteamobjscores" from here
	
	if ( teamScore == newScore )
		return;
	
	updateTeamScores( team );

	thread globallogic::checkScoreLimit();
}

function _setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	updateTeamScores( team );
	
	thread globallogic::checkScoreLimit();
}

function resetTeamScores()
{
	if ( level.scoreRoundWinBased || util::isFirstRound() )
	{
		foreach( team in level.teams )
		{
			game["teamScores"][team] = 0;
		}
	}
	
	globallogic_score::updateAllTeamScores();
}

function resetAllScores()
{
	resetTeamScores();
	resetPlayerScores();
}

function resetPlayerScores()
{
	players = level.players;
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{

		if ( isdefined( players[i].pers["score"] ) )
			_setPlayerScore( players[i], 0 );
		
	}
}

function updateTeamScores( team )
{
	setTeamScore( team, game["teamScores"][team] );
	level thread globallogic::checkTeamScoreLimitSoon( team );
}

function updateAllTeamScores( )
{
	foreach( team in level.teams )
	{
		updateTeamScores( team );
	}
}

function _getTeamScore( team )
{
	return game["teamScores"][team];
}

function getHighestTeamScoreTeam()
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

function areTeamArraysEqual( teamsA, teamsB )
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

function onTeamScore( score, team )
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
			globallogic_audio::leaderDialog( "lead_taken", team, "status" );
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
			globallogic_audio::leaderDialog( "lead_lost", team, "status" );
		}
	}
	
	level.wasWinning = isWinning;
}


function default_onTeamScore( event, team )
{
	/*score = _rank::getScoreInfoValue( event );
	
	assert( isdefined( score ) );

	onTeamScore( score, team );	*/
}

function initPersStat( dataName, record_stats, init_to_stat_value )
{
	if( !isdefined( self.pers[dataName] ) )
	{
		self.pers[dataName] = 0;
	}

	if ( !isdefined(record_stats) || record_stats == true )
	{
		recordPlayerStats( self, dataName, int(self.pers[dataName]) );
	}	

	if ( isdefined( init_to_stat_value ) && init_to_stat_value == true )
	{
		self.pers[dataName] = self GetDStat( "PlayerStatsList", dataName, "StatValue" );
	}	
}


function getPersStat( dataName )
{
	return self.pers[dataName];
}


function incPersStat( dataName, increment, record_stats, includeGametype )
{
	pixbeginevent( "incPersStat" );

	self.pers[dataName] += increment;
	
	if ( isdefined( includeGameType ) && includeGameType )
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

function threadedRecordPlayerStats( dataName )
{
	self endon("disconnect");
	waittillframeend;
	
	recordPlayerStats( self, dataName, self.pers[dataName] );
}

function updateWinStats( winner )
{
/*	winner AddPlayerStatWithGameType( "losses", -1 );
	
	winner AddPlayerStatWithGameType( "wins", 1 );
	winner UpdateStatRatio( "wlratio", "wins", "losses" );
	winner AddPlayerStat( "cur_win_streak", 1 );
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	winner notify( "win" );
	
	cur_gamemode_win_streak = winner _persistence::statGetWithGameType( "cur_win_streak" );
	gamemode_win_streak = winner _persistence::statGetWithGameType( "win_streak" );

	cur_win_streak = winner GetDStat( "playerstatslist", "cur_win_streak", "StatValue" );
	if ( cur_win_streak > winner getDStat( "HighestStats", "win_streak" ) )
	{
		winner setDStat( "HighestStats", "win_streak", cur_win_streak );
	}
	
	if ( cur_gamemode_win_streak > gamemode_win_streak )
	{
		winner _persistence::statSetWithGameType( "win_streak", cur_gamemode_win_streak );
	}*/
	
}

function updateLossStats( loser )
{	
	loser AddPlayerStatWithGameType( "losses", 1 );
	loser UpdateStatRatio( "wlratio", "wins", "losses" );
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	loser notify( "loss" );
}


function updateTieStats( loser )
{	
	loser AddPlayerStatWithGameType( "losses", -1 );
	
	loser AddPlayerStatWithGameType( "ties", 1 );
	loser UpdateStatRatio( "wlratio", "wins", "losses" );
	loser SetDStat( "playerstatslist", "cur_win_streak", "StatValue", 0 );		
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	loser notify( "tie" );
}

function updateWinLossStats( winner )
{
	if ( !util::wasLastRound() && !level.hostForcedEnd )
		return;
		
	players = level.players;

	if ( !isdefined( winner ) || ( isdefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isdefined( players[i].pers["team"] ) )
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
			if ( !isdefined( players[i].pers["team"] ) )
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
function backupAndClearWinStreaks()
{
	// Global
/*	self.pers[ "winStreak" ] = self GetDStat( "playerstatslist", "cur_win_streak", "StatValue" );
	self SetDStat( "playerstatslist", "cur_win_streak", "StatValue", 0 );	
	
	// Gametype
	self.pers[ "winStreakForGametype" ] = _persistence::statGetWithGameType( "cur_win_streak" ); 
	self _persistence::statSetWithGameType( "cur_win_streak", 0 );*/
}

function restoreWinStreaks( winner )
{
/*	// Global
	winner SetDStat( "playerstatslist", "cur_win_streak", "StatValue", winner.pers[ "winStreak" ] );
	
	// Gametype
	winner _persistence::statSetWithGameType( "cur_win_streak", winner.pers[ "winStreakForGametype" ] );*/
}

function incKillstreakTracker( weapon )
{
	self endon("disconnect");
	
	waittillframeend;
	
	if( weapon.name == "artillery" )
		self.pers["artillery_kills"]++;
	
	if( weapon.name == "dog_bite" )
		self.pers["dog_kills"]++;
}

function trackAttackerKill( name, rank, xp, prestige, xuid )
{
	self endon("disconnect");
	attacker = self;
	
	waittillframeend;

	pixbeginevent("trackAttackerKill");
	
	if ( !isdefined( attacker.pers["killed_players"][name] ) )
		attacker.pers["killed_players"][name] = 0;

	if ( !isdefined( attacker.killedPlayersCurrent[name] ) )
		attacker.killedPlayersCurrent[name] = 0;

	if ( !isdefined( attacker.pers["nemesis_tracking"][name] ) )
		attacker.pers["nemesis_tracking"][name] = 0;

	attacker.pers["killed_players"][name]++;
	attacker.killedPlayersCurrent[name]++;
	attacker.pers["nemesis_tracking"][name] += 1.0;
	if ( attacker.pers["nemesis_name"] == name ) 
	{
		attacker challenges::killedNemesis();
	}

	if( attacker.pers["nemesis_name"] == "" || attacker.pers["nemesis_tracking"][name] > attacker.pers["nemesis_tracking"][attacker.pers["nemesis_name"]] )
	{
		attacker.pers["nemesis_name"] = name;
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_rankIcon"] = prestige;
		attacker.pers["nemesis_xp"] = xp;
		attacker.pers["nemesis_xuid"] = xuid;
	}
	else if( isdefined( attacker.pers["nemesis_name"] ) && ( attacker.pers["nemesis_name"] == name ) )
	{
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_xp"] = xp;
	}
	
	pixendevent();
}

function trackAttackeeDeath( attackerName, rank, xp, prestige, xuid )
{
	self endon("disconnect");

	waittillframeend;

	pixbeginevent("trackAttackeeDeath");

	if ( !isdefined( self.pers["killed_by"][attackerName] ) )
		self.pers["killed_by"][attackerName] = 0;

		self.pers["killed_by"][attackerName]++;

	if ( !isdefined( self.pers["nemesis_tracking"][attackerName] ) )
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
	else if( isdefined( self.pers["nemesis_name"] ) && ( self.pers["nemesis_name"] == attackerName ) )
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

function default_isKillBoosting()
{
	return false;
}

function giveKillStats( sMeansOfDeath, weapon, eVictim )
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
	
	self globallogic_score::incPersStat( "kills", 1, true, true );
	self.kills = self globallogic_score::getPersStat( "kills" );
	self UpdateStatRatio( "kdratio", "kills", "deaths" );

	attacker = self;
	if ( sMeansOfDeath == "MOD_HEAD_SHOT" )//&& !_killstreaks::isKillstreakWeapon( weapon )  )
	{
		attacker thread incPersStat( "headshots", 1 , true, false );
		attacker.headshots = attacker.pers["headshots"];
		eVictim RecordKillModifier("headshot");
	}
	
	pixendevent();
}

function incTotalKills( team )
{
	if ( level.teambased && isdefined( level.teams[team] ) )
	{
		game["totalKillsTeam"][team]++;				
	}	
	
	game["totalKills"]++;			
}

function setInflictorStat( eInflictor, eAttacker, weapon )
{
	if ( !isdefined( eAttacker ) )
		return;

	if ( !isdefined( eInflictor ) )
	{
		eAttacker AddWeaponStat( weapon, "hits", 1 );
		return;
	}

	if ( !isdefined( eInflictor.playerAffectedArray ) )
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
		if( weapon == "concussion_grenade" || weapon == "tabun_gas" )
		{
			eAttacker AddWeaponStat( weapon, "used", 1 );
		}
		eAttacker AddWeaponStat( weapon, "hits", 1 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function processShieldAssist( killedplayer ) // self == riotshield player
{
	self endon( "disconnect" );
	killedplayer endon( "disconnect" );

	wait .05; // don't ever run on the same frame as the playerkilled callback.
	util::WaitTillSlowProcessAllowed();

	if ( !isdefined( level.teams[ self.pers["team"] ] )  )
		return;
	
	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;

	if ( !level.teambased )
		return;

	self globallogic_score::incPersStat( "assists", 1, true, true );

	self.assists = self globallogic_score::getPersStat( "assists" );
}

function processAssist( killedplayer, damagedone, weapon )
{
	self endon("disconnect");
	killedplayer endon("disconnect");
	
	wait .05; // don't ever run on the same frame as the playerkilled callback.
	util::WaitTillSlowProcessAllowed();
	
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
	
	self globallogic_score::incPersStat( "assists", 1, true, true );

	self.assists = self  globallogic_score::getPersStat( "assists" );

	switch( weapon.name )
	{
	case "concussion_grenade":
		assist_level = "assist_concussion";
		break;
	case "flash_grenade":
		assist_level = "assist_flash";
		break;
	case "emp_grenade":
		assist_level = "assist_emp";
		break;
	case "proximity_grenade":
	case "proximity_grenade_aoe":
		assist_level = "assist_proximity";
		break;
	}
	self challenges::assisted();
}

/#
function xpRateThread()
{
/*	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	while ( level.inPrematchPeriod )
		WAIT_SERVER_FRAME;

	for ( ;; )
	{
		wait ( 5.0 );
		if ( isdefined( level.teams[ level.players[0].pers["team"] ] )  )
			self _rank::giveRankXP( "kill", int(min( GetDvarint( "scr_xprate" ), 50 )) );
	}*/
}
#/
