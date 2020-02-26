#include maps\mp\_utility;

init()
{
	level.persistentDataInfo = [];
	level.maxRecentStats = 10;
	level.maxHitLocations = 19;
	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	level thread maps\mp\_challenges::init();
	level thread maps\mp\_medals::init();
	//level thread maps\mp\_properks::init();
	level thread maps\mp\_scoreevents::init();
	maps\mp\_popups::init();

	level thread onPlayerConnect();
	
	level thread initializeStatTracking();
	level thread uploadGlobalStatCounters();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player hashContractStats();
		player.enableText = true;
		player thread checkContractExpirations();
		player thread watchContractResets();
	}
}

initializeStatTracking()
{
	level.globalExecutions = 0;
	level.globalChallenges = 0;
	level.globalSharePackages = 0;
	level.globalContractsFailed = 0;
	level.globalContractsPassed = 0;
	level.globalContractsCPPaid = 0;
	level.globalKillstreaksCalled = 0;
	level.globalKillstreaksDestroyed = 0;
	level.globalKillstreaksDeathsFrom = 0;
	level.globalLarrysKilled = 0;
	level.globalBuzzKills = 0;
	level.globalRevives = 0;
	level.globalAfterlifes = 0;
	level.globalComebacks = 0;
	level.globalPaybacks = 0;
	level.globalBackstabs = 0;
	level.globalBankshots = 0;
	level.globalSkewered = 0;
	level.globalTeamMedals = 0;
	level.globalFeetFallen = 0;
	level.globalDistanceSprinted = 0;
	level.globalDemBombsProtected = 0;
	level.globalDemBombsDestroyed = 0;
	level.globalBombsDestroyed = 0;
	level.globalFragGrenadesFired = 0;
	level.globalSatchelChargeFired = 0;
	level.globalShotsFired = 0;
	level.globalCrossbowFired = 0;
	level.globalCarsDestroyed = 0;
	level.globalBarrelsDestroyed = 0;

	level.globalBombsDestroyedByTeam = [];
	
	foreach( team in level.teams )
	{
		level.globalBombsDestroyedByTeam[team] = 0;
	}
}

uploadGlobalStatCounters()
{
	level waittill("game_ended");
	
	if( GameModeIsMode( level.GAMEMODE_BASIC_TRAINING ) )
	{
		incrementCounter( "global_combattraining_botskilled", level.globalLarrysKilled );
		if ( wasLastRound() )
			incrementCounter( "global_combattraining_gamesplayed", 1 );
		return;
	}
	
	if ( !level.rankedMatch && !level.wagerMatch  ) 
		return;
		
	totalKills = 0;
	totalDeaths = 0;
	totalAssists = 0;
	totalHeadshots = 0;
	totalSuicides = 0;
	totalTimePlayed = 0;
	totalFlagsCaptured = 0;
	totalFlagsReturned = 0;
	totalHQsDestroyed = 0;
	totalHQsCaptured = 0;
	totalSDDefused = 0;
	totalSDPlants = 0;
	totalHumiliations = 0;	
	
	totalSabDestroyedByTeam = [];
	foreach ( team in level.teams )
	{
		totalSabDestroyedByTeam[team] = 0;
	}
	
	switch ( level.gameType )
	{
		case "dem":
		{
			bombZonesLeft = 0;
	
			for ( index = 0; index < level.bombZones.size; index++ )
			{
				if ( !isDefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
					level.globalDemBombsProtected++;
				else
					level.globalDemBombsDestroyed++;
			}
		}
		break;
		case "sab":
		{
			foreach ( team in level.teams )
			{
				totalSabDestroyedByTeam[team] = level.globalBombsDestroyedByTeam[team];
			}
		}
		break;		
	}

	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++)
	{
		player = players[i];
		totalTimePlayed += min( player.timePlayed["total"], level.timeplayedcap );
	}
		
	incrementCounter( "global_executions", level.globalExecutions );
	incrementCounter( "global_sharedpackagemedals", level.globalSharePackages );
	incrementCounter( "global_dem_bombsdestroyed", level.globalDemBombsDestroyed );
	incrementCounter( "global_dem_bombsprotected", level.globalDemBombsProtected );
	incrementCounter( "global_contracts_failed", level.globalContractsFailed );
	incrementCounter( "global_killstreaks_called", level.globalKillstreaksCalled );
	incrementCounter( "global_killstreaks_destroyed", level.globalKillstreaksDestroyed );
	incrementCounter( "global_killstreaks_deathsfrom", level.globalKillstreaksDeathsFrom );
	incrementCounter( "global_buzzkills", level.globalBuzzKills );
	incrementCounter( "global_revives", level.globalRevives );
	incrementCounter( "global_afterlifes", level.globalAfterlifes );
	incrementCounter( "global_comebacks", level.globalComebacks );
	incrementCounter( "global_paybacks", level.globalPaybacks );
	incrementCounter( "global_backstabs", level.globalBackstabs );
	incrementCounter( "global_bankshots", level.globalBankshots );
	incrementCounter( "global_skewered", level.globalSkewered );
	incrementCounter( "global_teammedals", level.globalTeamMedals );
	incrementCounter( "global_fraggrenadesthrown", level.globalFragGrenadesFired );
	incrementCounter( "global_c4thrown", level.globalSatchelChargeFired );
	incrementCounter( "global_shotsfired", level.globalShotsFired );
	incrementCounter( "global_crossbowfired", level.globalCrossbowFired );
	incrementCounter( "global_carsdestroyed", level.globalCarsDestroyed );
	incrementCounter( "global_barrelsdestroyed", level.globalBarrelsDestroyed );
	incrementCounter( "global_challenges_finished", level.globalChallenges );
	incrementCounter( "global_contractscppaid", level.globalContractsCPPaid );
	incrementCounter( "global_distancesprinted100inches", int( level.globalDistanceSprinted ) );	
	incrementCounter( "global_distancefeetfallen", int( level.globalFeetFallen ) );	
	incrementCounter( "global_minutes", int( totalTimePlayed / 60 ) );

	if ( !wasLastRound() )
		return;

	wait( 0.05 );
	
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++)
	{
		player = players[i];
		totalKills += player.kills;
		totalDeaths += player.deaths;
		totalAssists += player.assists;
		totalHeadshots += player.headshots;	
		totalSuicides += player.suicides;
		totalHumiliations += player.humiliated;
		totalTimePlayed += int( min( player.timePlayed["alive"], level.timeplayedcap ) );
		
		switch ( level.gameType )
		{
			case "ctf":
			{
				totalFlagsCaptured += player.captures;
				totalFlagsReturned += player.returns;
			}
			break;
			case "koth":
			{
				totalHQsDestroyed += player.destructions;
				totalHQsCaptured += player.captures;
			}
			break;
			case "sd":
			{
				totalSDDefused += player.defuses;
				totalSDPlants += player.plants;		
			}
			break;
			case "sab":
			{
				if ( isdefined(player.team) && isdefined( level.teams[ player.team ] ) )
				{
					totalSabDestroyedByTeam[player.team] += player.destructions;
				}
			}
			break;
		}
	}
		

	incrementCounter( "global_kills", totalKills );
	incrementCounter( "global_deaths", totalDeaths );
	incrementCounter( "global_assists", totalAssists );
	incrementCounter( "global_headshots", totalHeadshots );
	incrementCounter( "global_suicides", totalSuicides );
	incrementCounter( "global_games", 1 );
	incrementCounter( "global_ctf_flagscaptured", totalFlagsCaptured );
	incrementCounter( "global_ctf_flagsreturned", totalFlagsReturned );
	incrementCounter( "global_hq_destroyed", totalHQsDestroyed );
	incrementCounter( "global_hq_captured", totalHQsCaptured );
	incrementCounter( "global_snd_defuses", totalSDDefused );
	incrementCounter( "global_snd_plants", totalSDPlants );
	// TODO MTEAM - Need to update counters if we ever add a third team to sab
	incrementCounter( "global_sab_destroyedbyops", totalSabDestroyedByTeam["allies"] );
	incrementCounter( "global_sab_destroyedbycommunists", totalSabDestroyedByTeam["axis"] );
	incrementCounter( "global_humiliations", totalHumiliations );	
	if ( isdefined( game["wager_pot"] ) )
	{
		incrementCounter( "global_wageredcp", game["wager_pot"] );	
	}
}

// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

statGetWithGameType( dataName )
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return 0;
		
	if ( !level.onlineGame )
		return 0;
		
	return ( self getdstat( "PlayerStatsByGameType", getGameTypeName(), dataName, "StatValue" ) );
}

getGameTypeName()
{
	if ( !isDefined( level.fullGameTypeName ) )
	{
		if ( isDefined( level.hardcoreMode ) && level.hardcoreMode )
		{
			prefix = "HC";
		}
		else
		{
			prefix = "";
		}
		
		level.fullGameTypeName = toLower( prefix + level.gametype );
	}
	
	return level.fullGameTypeName;
	
}

getGameModeName()
{
	mode = "publicmatch";
	
	if ( GameModeIsMode( level.GAMEMODE_LEAGUE_MATCH ) )
	{
		mode = "leaguematch";
	}
	
	return mode;
}

isMilestoneValid( statName, currentMilestone, statType, itemGroup )
{
	if( !isDefined( level.statsMilestoneInfo[statType] ) )
	{
		return false;
	}
	
	if( !isDefined( level.statsMilestoneInfo[statType][statName] ) )
	{
		return false;
	}
	
	milestoneValid = ( isDefined( level.statsMilestoneInfo[statType][statName][currentMilestone] ) );
	
	if ( milestoneValid )
	{
		if ( level.statsMilestoneInfo[statType][statName][currentMilestone]["unlocklvl"] > self.pers["rank"] )
		{
			return false;
		}
	}
	
	if ( isDefined( itemGroup ) && itemGroup != "" && milestoneValid )
	{
		if ( IsSubStr( level.statsMilestoneInfo[statType][statName][currentMilestone]["exclude"], itemGroup ) )
		{
			return false;
		}
	}
	
	return milestoneValid;
	
}

setChallengeOrStat( baseName, item, statName, incValue, statType )
{
	statValue = self getDStat( baseName, item, "stats", statName, statType );
	statValue += incValue;
		
	if ( statValue < 0 )
	{
		statValue = 0;
	}
	
	self setDStat( baseName, item, "stats", statName, statType, statValue );
	
	return statValue;
}

setWeaponChallengeOrStat( itemIndex, statName, incValue, statType )
{
	return self setChallengeOrStat( "itemStats", itemIndex, statName, incValue, statType );
}

getItemIndexFromName( nameString )
{
	itemIndex = int( tableLookup( "mp/statstable.csv", 3, nameString, 0 ) );
	assert( itemIndex > 0, "statsTable nameString " + nameString + " has invalid index: " + itemIndex );
	
	return itemIndex;
}

unlockItemFromChallenge( unlockItem )
{
	if ( !IsDefined( unlockItem ) )
	{
		return;
	}
	
	unlock_tokens = strtok( unlockItem, " " );
	if( isdefined( unlock_tokens ) && unlock_tokens.size != 0 )
	{
		if ( ( unlock_tokens[ 0 ] == "perkpro" ) && ( unlock_tokens.size == 3 ) )
		{
			self setDStat( "ItemStats", getItemIndexFromName( unlock_tokens[ 1 ] ), "isProVersionUnlocked", int( unlock_tokens[ 2 ] ), 1 );
		}
	}
}

checkMilestoneComplete( statName, statValue, statType, challengeName, lifeTime )
{
	if ( !statValue || !level.rankedMatch )
	{
		return false;
	}
	
	if ( !isDefined( lifeTime ) )
	{
		lifeTime = "";
	}
	
	oldStatName = statName;
	
	statName = lifeTime + oldStatName;
	
	currentMilestone = 0;
	
	milestoneType = "global";
	gameType = getGameTypeName();
	
	// Check it once with a fake value (0) to see if we're even interested in this stat for a milestone
	if ( !( self isMilestoneValid( statName, currentMilestone, statType ) ) )
	{
		return false;
	}	
	
	if ( statType == "global" )
	{
		currentMilestone = self getDStat( challengeName, oldStatName );
	}
	else if ( statType == "gamemode" )
	{
		currentMilestone = self getDStat( "CurrentGameModeMilestone", gameType, "milestones", oldStatName );
		milestoneType = gameType;
	}
	
	// Check if this milestone exists
	if ( !( self isMilestoneValid( statName, currentMilestone, statType ) ) )
	{
		return false;
	}
	
	while( statValue >= level.statsMilestoneInfo[statType][statName][currentMilestone]["maxval"] )
	{
		index = level.statsMilestoneInfo[statType][statName][currentMilestone]["index"];
	
		self thread maps\mp\_popups::milestoneNotify( index, 0, milestoneType, currentMilestone );
		
		self AddRankXPValue( "challenge", level.statsMilestoneInfo[statType][statName][currentMilestone]["xpreward"] );
		self maps\mp\gametypes\_rank::incCodPoints( level.statsMilestoneInfo[statType][statName][currentMilestone]["cpreward"] );
		self unlockItemFromChallenge( level.statsMilestoneInfo[statType][statName][currentMilestone]["unlockitem"] );
	
		currentMilestone++;
		
		if ( statType == "global" )
		{
			self setDStat( challengeName, oldStatName, currentMilestone );
		}
		else if ( statType == "gamemode" )
		{
			self setDStat( "CurrentGameModeMilestone", gameType, "milestones", statName, currentMilestone );
		}
	
		if ( !( self isMilestoneValid( statName, currentMilestone, statType ) ) )
		{
			return true;
		}
	}
	
	return true;
	
}

isStatModifiable( dataName )
{
	return level.rankedMatch || level.wagerMatch;
}

statSetWithGameType( dataName, value, incValue )
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return 0;

	if ( !isStatModifiable( dataName ) )
		return;
		
	contractsToProcess = self getContractsToProcess( "gametype", toLower( dataName ) );
		
	if ( contractsToProcess.size )
	{
		if ( !isDefined( incValue ) )
		{
			increase = ( value - self getdstat( "PlayerStatsByGameType", getGameTypeName(), dataName, "StatValue" ) );		
		}
		else
		{
			increase = incValue;
		}
		self processContracts( contractsToProcess, "gametype", dataName, increase );
	}
	
	self setdstat( "PlayerStatsByGameType", getGameTypeName(), dataName, "StatValue", value );
	
	if ( isDefined( incValue ) )
	{
		challengeValue = self getdstat( "PlayerChallengeByGameMode", getGameTypeName(), dataName );
		
		newValue = challengeValue + incValue;
		
		updateStats = checkMilestoneComplete( dataName, newValue, "gamemode" );
		
		if ( updateStats )
		{
			self setdstat( "PlayerChallengeByGameMode", getGameTypeName(), dataName, newValue );
		}
	}
}

adjustRecentStats()
{
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/

	self endon("disconnect");
	
	self waittill("spawned_player");

	initializeMatchStats();
	//adjustRecentScores( false );
	//adjustRecentScores( true );
	//adjustRecentHitLocStats();
}

getRecentStat( isGlobal, index, statName )
{
	if( level.wagerMatch )
	{
		return self getdstat( "RecentEarnings", index, statName );
	}
	else if( isGlobal )
	{
		modeName = maps\mp\gametypes\_globallogic::GetCurrentGameMode();
		return self getdstat( "gameHistory", modeName, "matchHistory", index, statName );
	}
	else 
	{
		return self getdstat( "PlayerStatsByGameType", getGameTypeName(), "prevScores" , index, statName );
	}
}

setRecentStat( isGlobal, index, statName, value )
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !isStatModifiable( statName ) )
		return;

	if( index < 0 || index > 9 )
		return;

	if( level.wagerMatch )
	{
		self setdstat( "RecentEarnings", index, statName, value );
	}
	else if( isGlobal )
	{
		modeName = maps\mp\gametypes\_globallogic::GetCurrentGameMode();
		self setdstat( "gameHistory", modeName, "matchHistory", "" + index, statName, value );
		return;
	}
	else 
	{
		self setdstat( "PlayerStatsByGameType", getGameTypeName(), "prevScores" , index, statName, value );
		return;
	}
}

addRecentStat( isGlobal, index, statName, value )
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !isStatModifiable( statName ) )
		return;

	currStat = getRecentStat( isGlobal, index, statName );
	setRecentStat( isGlobal, index, statName, currStat + value );
}

setMatchHistoryStat( statName, value )
{
	modeName = maps\mp\gametypes\_globallogic::GetCurrentGameMode();
	historyIndex = self GetDStat( "gameHistory", modeName, "currentMatchHistoryIndex" );

	setRecentStat( true, historyIndex, statName, value );
}

//adjustRecentHitLocStats()
//{
//	if( isDefined( level.noPersistence ) && level.noPersistence )
//		return;
//
//	if ( !level.onlineGame )
//		return;
//
//	if ( level.wagerMatch )
//		return;
//
//	if ( !level.rankedMatch )	
//		return; 
//
//	locationIndex = self GetDStat( "currentHitLocationIndex" );
//	locationIndex = locationIndex + 1;
//	if ( locationIndex > self GetDStatArrayCount( "RecentHitLocCounts" ) )
//	{
//		locationIndex = 0;
//	}
//	
//	self setdstat( "currentHitLocationIndex", locationIndex );
//	self setdstat( "RecentHitLocCounts", locationIndex, "valid", 1 );
//	
//	for ( k = 0; k < level.maxHitLocations; k++ )
//	{
//		self setdstat( "RecentHitLocCounts", locationIndex, "hitLocations", k, 0 );
//		self setdstat( "RecentHitLocCounts", locationIndex, "criticalHitLocations", k, 0 );
//	}
//}

initializeMatchStats()
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !( level.rankedMatch || level.wagerMatch ) )	
		return; 

	self.pers["lastHighestScore"] =  self getDStat( "HighestStats", "highest_score" );

	currGameType = maps\mp\gametypes\_persistence::getGameTypeName();
	self GameHistoryStartMatch( getGameTypeEnumFromName( currGameType, level.wagerMatch ) );
	
//	modeName = maps\mp\gametypes\_globallogic::GetCurrentGameMode();
//	historyIndex = self GetDStat( "gameHistory", modeName, "currentMatchHistoryIndex" );
//	historyIndex = historyIndex + 1;
//	if ( historyIndex > GetDStatArrayCount( "gameHistory", modeName, "matchHistory" ) )
//	{
//		historyIndex = 0;
//	}
//	self SetDStat( "gameHistory", modeName, "currentMatchHistoryIndex", historyIndex );
//	
//	setRecentStat( isGlobal, historyIndex, "score", 0 );
//	setRecentStat( isGlobal, historyIndex, "kills", 0 );
//	setRecentStat( isGlobal, historyIndex, "deaths", 0 );
//	setRecentStat( isGlobal, historyIndex, "quitType", 0 ); // assume dashboard
//	setRecentStat( isGlobal, historyIndex, "teamScoreRatio", 0 );
//	setRecentStat( isGlobal, historyIndex, "scoreboardPosition", 0 );
//
//	setRecentStat( isGlobal, historyIndex, "gameType", getGameTypeEnumFromName( currGameType, level.wagerMatch ) );
//	setRecentStat( isGlobal, historyIndex, "startingTime", 0 );
}

setAfterActionReportStat( statName, value, index )
{
	if( self is_bot() )
		return;
	
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/
	
	if ( level.rankedMatch || level.wagerMatch || level.leagueMatch )
	{
		if ( IsDefined( index ) )
			self setdstat( "AfterActionReportStats", statName, index, value );
		else
			self setdstat( "AfterActionReportStats", statName, value );
	}
}

getContractsToProcess( statType, statName )
{
	activeContractIndices = [];
	
	if ( !IsDefined( self ) )
		return activeContractIndices;
		
	if ( !level.contractsEnabled )
		return activeContractIndices;
		
	if( self is_bot() )
		return activeContractIndices;
	
	if ( IsDefined( self.contractStatTypes ) && IsDefined( self.contractStats ) )
	{
		assert( self.contractStatTypes.size == self.contractStats.size );
		numContracts = self.contractStatTypes.size;
		for ( i = 0 ; i < numContracts ; i++ )
		{
			if ( self.contractStatTypes[i] == statType && self.contractStats[i] == statName )
			{
				activeContractIndices[activeContractIndices.size] = i;
			}
		}
	}
	
	return activeContractIndices;
}

processContracts( activeContractIndices, statType, statName, incValue, weapon )
{
	if( level.wagerMatch )
		return;
	
	if ( !level.contractsEnabled )
		return;
		
	if ( incValue <= 0 )
		return;
		
	if( self is_bot() )
		return;
	
	numActiveContracts = activeContractIndices.size;
	for ( i = 0 ; i < numActiveContracts ; i++ )
	{	
		activeContractIndex = activeContractIndices[i];
		contractIndex = self GetIndexForActiveContract( activeContractIndex );
		if ( toLower( GetContractStatType( contractIndex ) ) == toLower( statType ) && toLower( GetContractStatName( contractIndex ) ) == toLower( statName ) )
		{
			if ( contractRequirementsMet( contractIndex, weapon ) )
			{								
				wasComplete = self IsActiveContractComplete( activeContractIndex );
				
				// Update contract progress
				self IncrementActiveContractProgress( activeContractIndex, incValue );
				
				// Check for contract completion
				if ( !wasComplete && self IsActiveContractComplete( activeContractIndex ) )
				{
					bbPrint( "contract_complete", "xuid %s name %s contractid %d contractname %s timepassed %d requiredcount %d rewardxp %d rewardcp %d", self GetXUID(), self.name, contractIndex, GetContractName( contractIndex ), self GetActiveContractTimePassed( activeContractIndex ), GetContractRequiredCount( contractIndex ), GetContractRewardXP( contractIndex ), GetContractRewardCP( contractIndex ) );
					self giveContractRewards( contractIndex );
				}
			}
		}	
	}
}

giveContractRewards( contractIndex )
{
	if ( !level.contractsEnabled )
			return;

	addContractToQueue( contractIndex, true );
	
	rewardXP = GetContractRewardXP( contractIndex );
	if ( rewardXP > 0 )
	{
		self AddRankXPValue( "contract", rewardXP );
		//self AddPlayerStat( "CONTRACTS_XP_EARNED", rewardXP );
	}
		
	rewardCP = GetContractRewardCP( contractIndex );
	level.globalContractsPassed += 1;
	level.globalContractsCPPaid += rewardCP;

	if ( rewardCP > 0 )
	{
		self maps\mp\gametypes\_rank::incCodPoints( rewardCP );
		//self AddPlayerStat( "CONTRACTS_CP_EARNED", rewardCP );
	}
	
	//self AddPlayerStat( "CONTRACTS_COMPLETED", 1 );
}

CodeCallback_ChallengeComplete( rewardXP, maxVal, row, tableNumber, challengeType, itemIndex, challengeIndex )
{
	self LUINotifyEvent( &"challenge_complete", 7, challengeIndex, itemIndex, challengeType, tableNumber, row, maxVal, rewardXP );
}

CodeCallback_GunChallengeComplete( rewardXP, attachmentIndex, itemIndex, rankID )
{
	self LUINotifyEvent( &"gun_level_complete", 4, rankID, itemIndex, attachmentIndex, rewardXP );
}

watchContractResets()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if ( !level.contractsEnabled )
		return;
	
	maxActiveContracts = GetMaxActiveContracts();
	for ( i = 0 ; i < maxActiveContracts ; i++ )
	{
		contractIndex = self GetIndexForActiveContract( i );
		if ( contractIndex < 0 )
			continue;
			
		resetConditions = GetContractResetConditions( contractIndex );			
		if ( resetConditions == "" )
			continue;
			
		resetConditions = strtok( resetConditions, "," );
		if ( !isDefined( resetConditions ) || !isDefined( resetConditions.size ) || !resetConditions.size )
			continue;
			
		for ( j = 0 ; j < resetConditions.size ; j++ )
		{
			self thread watchContractReset( i, resetConditions[j] );
		}
	}
	
	if ( isOneRound() || isFirstRound() )
		self notify( "new_match" );
		
	self notify( "new_round" );
}

watchContractReset( activeContractIndex, resetCondition )
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	for ( ;; )
	{
		self waittill( resetCondition );
		self ResetActiveContractProgress( activeContractIndex );
	}
}

hashContractStats()
{
	self.contractStats = [];
	self.contractStatTypes = [];
	maxActiveContracts = GetMaxActiveContracts();
	for ( i = 0 ; i < maxActiveContracts ; i++ )
	{
		contractIndex = self GetIndexForActiveContract( i );
		statType = toLower( GetContractStatType( contractIndex ) );
		self.contractStatTypes[i] = statType;
		self.contractStats[i] = toLower(GetContractStatName( contractIndex ));
	}
}

checkContractExpirations()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if ( !IsDefined( self.contractExpirations ) )
			self.contractExpirations = [];
			
	if ( !level.contractsEnabled )
		return;
		
	if( self is_bot() )
		return;
	
	maxActiveContracts = GetMaxActiveContracts();
	for ( i = 0 ; i < maxActiveContracts ; i++ )
	{
		contractExpired = self HasActiveContractExpired( i );
		if ( contractExpired && IsDefined( self.contractExpirations[i] ) && !self.contractExpirations[i] )
		{
			// Contract just expired
			contractIndex = self GetIndexForActiveContract( i );
			if ( contractIndex < 0 )
				return; // This should never happen

			level.globalContractsFailed += 1;
			
			addContractToQueue( contractIndex, false );
			bbPrint( "contract_expired", "xuid %s name %s contractid %d contractname %s timepassed %d progress %d requiredcount %d", self GetXUID(), self.name, contractIndex, GetContractName( contractIndex ), self GetActiveContractTimePassed( i ), self GetActiveContractProgress( i ), GetContractRequiredCount( contractIndex ) );

		}
		self.contractExpirations[i] = contractExpired;
	}
}

incrementContractTimes( timeInc )
{
	if( !level.rankedMatch || level.wagerMatch )
		return;

	if ( !level.contractsEnabled )
		return;
	
	maxActiveContracts = GetMaxActiveContracts();
	for ( i = 0 ; i < maxActiveContracts ; i++ )
	{
		contractIndex = self GetIndexForActiveContract( i );
		if ( contractIndex < 0 )
			continue;
		requirements = GetContractRequirements( contractIndex );
		numRequirements = requirements.size;
		incContractTime = true;
		for ( j = 0 ; j < numRequirements ; j += 2 )
		{
			if ( requirements[j] == "map" && !self contractRequirementMet( requirements[j], requirements[j+1] ) )
			{
				incContractTime = false;
				break;
			}
			else if ( requirements[j] == "gametype" && !self contractRequirementMet( requirements[j], requirements[j+1] ) )
			{
				incContractTime = false;
				break;
			}
		}
		if ( incContractTime )
		{
			self IncrementActiveContractTime( i, timeInc );
		}
	}
}

contractRequirementsMet( contractIndex, weapon )
{
	requirements = GetContractRequirements( contractIndex );
	for ( i = 0 ; i < requirements.size ; i += 2 )
	{
		if ( !self contractRequirementMet( requirements[i], requirements[i+1], weapon ) )
			return false;
	}
	
	return true;
}

contractRequirementMet( reqType, reqData, weapon )
{
	reqData = strtok( reqData, "," );
	if ( reqType == "map" )
	{
		return checkGenericContractRequirement( GetDvar( "mapname" ), reqData );
	}
	else if ( reqType == "gametype" )
	{
		return checkGenericContractRequirement( getGametypeName(), reqData );
	}
	else if ( reqType == "head" )
	{
		return checkGenericContractRequirement( self.cac_head_type, reqData );
	}
	else if ( reqType == "body" )
	{
		return checkGenericContractRequirement( self.cac_body_type, reqData );
	}
	else if ( reqType == "baseweapon" )
	{
		return self checkBaseWeaponContractRequirement( reqData, weapon );
	}
	else if ( reqType == "weapon_substr" )
	{
		return self checkWeaponSubstringContractRequirement( reqData, weapon );
	}
	else if ( reqType == "perk" )
	{
		return self checkPerkContractRequirement( reqData );
	}
	else if ( reqType == "kdratio" )
	{
		return self checkKDRatioRequirement( reqData );
	}
	else if ( reqType == "ads" )
	{
		return self checkGenericContractRequirementFloat( self PlayerADS(), reqData );
	}
	else if ( reqType == "inventorytype" )
	{
		if ( !IsDefined( weapon ) )
			return false;
		return self checkGenericContractRequirement( toLower( WeaponInventoryType( weapon ) ), reqData );
	}
	else if ( reqType == "nonkillstreak" )
	{
		if ( !IsDefined( weapon ) )
			return false;
		return !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon );
	}
	else
	{
	/#	println( "ERROR: Invalid contract requirement type!" );		#/
	}
	return false;
}

checkGenericContractRequirement( playerValue, validValues )
{
	if ( !isDefined( validValues ) || !isDefined( validValues.size ) || !validValues.size )
		return false;
		
	for ( i = 0 ; i < validValues.size ; i++ )
	{
		if ( playerValue == validValues[i] )
			return true;
	}
	
	return false;
}

checkGenericContractRequirementFloat( playerValue, validValues )
{
	if ( !isDefined( validValues ) || !isDefined( validValues.size ) || !validValues.size )
		return false;

	for ( i = 0 ; i < validValues.size ; i++ )
	{
		if ( playerValue == float( validValues[i] ) )
			return true;
	}

	return false;
}

checkKDRatioRequirement( reqRatios )
{
	if ( IsDefined( reqRatios ) && IsDefined( reqRatios.size ) && ( reqRatios.size == 1 ) )
	{
		numKills = self.kills; 
		numDeaths = self.deaths; 
		if ( numDeaths == 0 )
		{
			numDeaths = 1;
		}
		
		kdRatio = float( numKills ) / numDeaths;
		if ( kdRatio >= float( reqRatios[0] ) )
		{
			return true;
		}
	}
	
	return false;
}

checkBaseWeaponContractRequirement( validWeapons, weapon )
{
	if ( !isDefined( validWeapons ) || !isDefined( validWeapons.size ) || !validWeapons.size || !IsDefined( weapon ) )
		return false;
		
	baseWeaponName = GetRefFromItemIndex( GetBaseWeaponItemIndex( weapon ) );
		
	for ( i = 0 ; i < validWeapons.size ; i++ )
	{
		if ( toLower( baseWeaponName ) == toLower( validWeapons[i] ) )
			return true;
	}
	
	return false;
}

checkWeaponSubstringContractRequirement( validSubstrings, weapon )
{
	if ( !isDefined( validSubstrings ) || !isDefined( validSubstrings.size ) || !validSubstrings.size || !IsDefined( weapon ) )
		return false;
		
	for ( i = 0 ; i < validSubstrings.size ; i++ )
	{
		if ( IsSubStr( toLower( weapon ), toLower( validSubstrings[i] ) ) )
			return true;
	}
	
	return false;
}

checkPerkContractRequirement( validPerks )
{
	if ( !isDefined( validPerks ) || !isDefined( validPerks.size ) || !validPerks.size )
		return false;
	
	for ( i = 0 ; i < validPerks.size ; i++ )
	{
		if ( self HasPerk( validPerks[i] ) )
			return true;
	}
	
	return false;
}

addContractToQueue( index, passed )
{
	size = self.pers["contractNotifyQueue"].size;
	self.pers["contractNotifyQueue"][size] = [];
	self.pers["contractNotifyQueue"][size]["index"] = index;
	self.pers["contractNotifyQueue"][size]["passed"] = passed;

	self notify( "received award" );
}

uploadStatsSoon()
{
	self notify( "upload_stats_soon" );
	self endon( "upload_stats_soon" );
	self endon( "disconnect" );

	wait 1;
	UploadStats( self );
}

CodeCallback_OnAddPlayerStat(dataName, value)
{
	self ProcessContractsOnAddStat("player", dataName, value);
}

CodeCallback_OnAddWeaponStat(weapName, dataName, value)
{
	self ProcessContractsOnAddStat("weapon", dataName, value, weapName);
}

ProcessContractsOnAddStat(statType, dataName, value, weapName)
{
	contractsToProcess = self getContractsToProcess( statType, toLower( dataName ) );
	
	if ( contractsToProcess.size )
	{
		self processContracts( contractsToProcess, statType, dataName, value, weapName);
	}
}
