#include maps\mp\_utility;

init()
{
	level.persistentDataInfo = [];
	level.maxRecentStats = 10;
	level.maxHitLocations = 19;
	maps\mp\gametypes\_class::init();
	maps\mp\gametypes\_rank::init();
	maps\mp\gametypes\_missions::init();
	level thread maps\mp\_challenges::init();
	level thread maps\mp\_medals::init();
	level thread maps\mp\_properks::init();
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
		player thread checkChallengeComplete();
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
	level.globalBombsDestroyedByOps = 0;
	level.globalBombsDestroyedByCommunists = 0;
	level.globalFragGrenadesFired = 0;
	level.globalSatchelChargeFired = 0;
	level.globalShotsFired = 0;
	level.globalCrossbowFired = 0;
	level.globalCarsDestroyed = 0;
	level.globalBarrelsDestroyed = 0;

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
	totalSabDestroyedByOps = 0;
	totalSabDestroyedByCommunists = 0;
	totalHumiliations = 0;	

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
			totalSabDestroyedByOps = level.globalBombsDestroyedByOps;
			totalSabDestroyedByCommunists = level.globalBombsDestroyedByCommunists;
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
				if ( player.team == "allies" )
				{
					totalSabDestroyedByOps += player.destructions;
				}
				else
				{
					totalSabDestroyedByCommunists += player.destructions;
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
	incrementCounter( "global_sab_destroyedbyops", totalSabDestroyedByOps );
	incrementCounter( "global_sab_destroyedbycommunists", totalSabDestroyedByCommunists );
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
		
	return ( self getdstat( "PlayerStatsByGameMode", getGameTypeName(), dataName, "StatValue" ) );
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
	
		self thread maps\mp\gametypes\_missions::milestoneNotify( index, 0, milestoneType, currentMilestone );
		
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
			increase = ( value - self getdstat( "PlayerStatsByGameMode", getGameTypeName(), dataName, "StatValue" ) );		
		}
		else
		{
			increase = incValue;
		}
		self processContracts( contractsToProcess, "gametype", dataName, increase );
	}
	
	self setdstat( "PlayerStatsByGameMode", getGameTypeName(), dataName, "StatValue", value );
	
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

	adjustRecentScores( false );
	adjustRecentScores( true );
	adjustRecentHitLocStats();
}

getRecentStat( isGlobal, index, statName )
{
	if( isGlobal && !level.wagerMatch )
	{
		return self getdstat( "RecentScores", index, statName );
	}
	else if( !isGlobal && !level.wagerMatch )
	{
		return self getdstat( "PlayerStatsByGameMode", getGameTypeName(), "prevScores" , index, statName );
	}

	if( level.wagerMatch )
	{
		return self getdstat( "RecentEarnings", index, statName );
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

	if( isGlobal && !level.wagerMatch )
	{
		self setdstat( "RecentScores", index, statName, value );
		return;
	}
	else if( !isGlobal && !level.wagerMatch )
	{
		self setdstat( "PlayerStatsByGameMode", getGameTypeName(), "prevScores" , index, statName, value );
		return;
	}

	if( level.wagerMatch )
	{
		self setdstat( "RecentEarnings", index, statName, value );
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

adjustRecentHitLocStats()
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return;

	if ( !level.onlineGame )
		return;

	if ( level.wagerMatch )
		return;

	if ( !level.rankedMatch )	
		return; 

	for ( i = 0; i < level.maxRecentStats-1; i++ )
	{
		isValid = self getdstat( "RecentHitLocCounts", i, "valid" );
		if ( !isValid )
		{
			break;
		}
	}

	for ( j = i-1; j >= 0; j-- )
	{
		for ( k = 0; k < level.maxHitLocations; k++ )
		{
			currHitLocCount = self getdstat( "RecentHitLocCounts", j, "hitLocations", k );
			self setdstat( "RecentHitLocCounts", j+1, "hitLocations", k, currHitLocCount );
			currHitLocCount = self getdstat( "RecentHitLocCounts", j, "criticalHitLocations", k );
			self setdstat( "RecentHitLocCounts", j+1, "criticalHitLocations", k, currHitLocCount );
		}
		self setdstat( "RecentHitLocCounts", j+1, "valid", 1 );
	}

	self setdstat( "RecentHitLocCounts", 0, "valid", 1 );
}

adjustRecentScores( isGlobal )
{
	if( isDefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !( level.rankedMatch || level.wagerMatch ) )	
		return; 

	if ( isGlobal && level.wagerMatch )
		return; 

	kills = 0;
	deaths = 0;
	gameType = 0;
	currScore = 0;

	for ( i = 0; i < level.maxRecentStats-1; i++ )
	{
		isValid = self getRecentStat( isGlobal, i, "valid" );

		if ( !isValid )
		{
			break;
		}
	}
	
	for ( j = i-1; j >= 0; j-- )
	{
		currScore = self getRecentStat( isGlobal, j, "score" );

		if( isGlobal && !level.wagerMatch )
		{
			kills = self getRecentStat( isGlobal, j, "kills" );
			deaths = self getRecentStat( isGlobal, j, "deaths" );
			gameType = self getRecentStat( isGlobal, j, "gameType" );
		}

		self setRecentStat( isGlobal, j+1, "score", currScore );
		self setRecentStat( isGlobal, j+1, "valid", 1 );

		if( isGlobal && !level.wagerMatch )
		{
			self setRecentStat( isGlobal, j+1, "kills", kills );
			self setRecentStat( isGlobal, j+1, "deaths", deaths );
			self setRecentStat( isGlobal, j+1, "gameType", gameType );
		}
	}
	
	self setRecentStat( isGlobal, 0, "score", 0 );
	self setRecentStat( isGlobal, 0, "valid", 1 );

	if ( isGlobal && !level.wagerMatch )
	{
		self setRecentStat( isGlobal, 0, "kills", 0 );
		self setRecentStat( isGlobal, 0, "deaths", 0 );
		currGameType = getGameTypeName();
//		self setRecentStat( isGlobal, 0, "gameType", getGameTypeEnumFromName( currGameType, level.wagerMatch ) );
	}

	self.pers["lastHighestScore"] =  self getDStat( "HighestStats", "highest_score" );
}

setAfterActionReportStat( statName, value, index )
{
	if( self is_bot() )
		return;
	
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/
	
	if ( level.rankedMatch || level.wagerMatch )
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
		self AddPlayerStat( "CONTRACTS_XP_EARNED", rewardXP );
	}
		
	rewardCP = GetContractRewardCP( contractIndex );
	level.globalContractsPassed += 1;
	level.globalContractsCPPaid += rewardCP;

	if ( rewardCP > 0 )
	{
		self maps\mp\gametypes\_rank::incCodPoints( rewardCP );
		self AddPlayerStat( "CONTRACTS_CP_EARNED", rewardCP );
	}
	
	self AddPlayerStat( "CONTRACTS_COMPLETED", 1 );
}

CodeCallback_ChallengeComplete( challengeIndex, groupName, itemIndex )
{
	size = self.pers[ "challengeQueue" ].size;
	
	self.pers[ "challengeQueue" ][ size ] = [];
	self.pers[ "challengeQueue" ][ size ][ "challengeIndex" ] = challengeIndex;
	self.pers[ "challengeQueue" ][ size ][ "groupName" ] = groupName;
	self.pers[ "challengeQueue" ][ size ][ "itemIndex" ] = itemIndex;
}

CodeCallback_GunChallengeComplete( rewardXP, attachmentName, itemIndex, rankID )
{
	size = self.pers[ "gunChallengeQueue" ].size;
	
	self.pers[ "gunChallengeQueue" ][ size ] = [];
	self.pers[ "gunChallengeQueue" ][ size ][ "rankID" ] = rankID;
	self.pers[ "gunChallengeQueue" ][ size ][ "itemIndex" ] = itemIndex;
	self.pers[ "gunChallengeQueue" ][ size ][ "rewardXP" ] = rewardXP;
	self.pers[ "gunChallengeQueue" ][ size ][ "attachment" ] = attachmentName;
}

checkChallengeComplete()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	if ( !isDefined( self.pers[ "challengeQueue" ] ) )
	{
		self.pers[ "challengeQueue" ]= [];
	}
	
	if ( !isDefined( self.pers[ "gunChallengeQueue" ] ) )
	{
		self.pers[ "gunChallengeQueue" ]= [];
	}

	
	while(1)
	{
		wait( 1.0 );
		
		size = self.pers[ "challengeQueue" ].size;
		if ( size )
		{
			challengeIndex =  self.pers[ "challengeQueue" ][ 0 ][ "challengeIndex" ];
			groupName = self.pers[ "challengeQueue" ][ 0 ][ "groupName" ];
			itemIndex = self.pers[ "challengeQueue" ][ 0 ][ "itemIndex" ];
			
			currentLevel = level.challengeTable[ challengeIndex ][ "level" ];
			
			self thread maps\mp\gametypes\_missions::milestoneNotify( challengeIndex, itemIndex, groupName, currentLevel );		
			
			self AddRankXPValue( "challenge", level.challengeTable[ challengeIndex ][ "xpreward" ] );
			self maps\mp\gametypes\_rank::incCodPoints( level.challengeTable[ challengeIndex ][ "cpreward" ] );
			self unlockItemFromChallenge( level.challengeTable[ challengeIndex ]["unlockitem"] );
		
			// self setDStat( baseName, itemGroup, "stats", oldStatName, challengeName, currentMilestone );
			// set maxval too
			
			for ( n = 1; n < size; n++ )
			{
				self.pers[ "challengeQueue" ][ n - 1 ] = self.pers[ "challengeQueue" ][ n ];
			}
			self.pers[ "challengeQueue" ][ size - 1 ] = undefined;
		}
	}
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
		println( "ERROR: Invalid contract requirement type!" );
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