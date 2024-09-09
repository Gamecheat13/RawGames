#include maps\mp\_utility;


//===========================================
// 				constants
//===========================================
CONST_SCORE_FACTOR_MIN				= 0;
CONST_SCORE_FACTOR_MAX 				= 100;
CONST_PLAYER_DISTANCE_MAX			= 3000;
CONST_NEARBY_DISTANCE				= 500;
CONST_EXPLOSIVE_RANGE_SQUARDED		= 350 * 350;
CONST_CARE_PACKAGE_RADIUS_SQUARED	= 150 * 150;
CONST_REVENGE_DISTANCE_SQUARED		= 2000 * 2000;
CONST_ENEMY_SPAWN_TIME_LIMIT		= 500;


//===========================================
// 				score_factor
//===========================================
score_factor( weight, spawnFactorFunction, spawnPoint, optionalParam )
{
	if( IsDefined( optionalParam ) )
	{
		scoreFactor = [[spawnFactorFunction]]( spawnPoint, optionalParam );
	}
	else
	{
		scoreFactor = [[spawnFactorFunction]]( spawnPoint );
	}
	
	scoreFactor = clamp( scoreFactor, CONST_SCORE_FACTOR_MIN, CONST_SCORE_FACTOR_MAX );
	scoreFactor *= weight;
	
	/#
	spawnPoint.debugScoreData[spawnPoint.debugScoreData.size] = scoreFactor;
	spawnPoint.totalPossibleScore += CONST_SCORE_FACTOR_MAX * weight;
	#/
		
	return scoreFactor;
}


//===========================================
// 				critical_factor
//===========================================
critical_factor( spawnFactorFunction, spawnPoint )
{
	scoreFactor = [[spawnFactorFunction]]( spawnPoint );
	
	scoreFactor = clamp( scoreFactor, CONST_SCORE_FACTOR_MIN, CONST_SCORE_FACTOR_MAX );
	
	/#
	spawnPoint.debugCriticalData[spawnPoint.debugCriticalData.size] = scoreFactor;
	#/
		
	return scoreFactor;
}


//===========================================
// 			avoidCarePackages
//===========================================
avoidCarePackages( spawnPoint )
{	
	foreach( carePackage in level.carePackages )
	{
		if( !isdefined( carePackage ) )
			continue;
		
		if( DistanceSquared( spawnPoint.origin, carePackage.origin) < CONST_CARE_PACKAGE_RADIUS_SQUARED )
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
	
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 				avoidGrenades
//===========================================
avoidGrenades( spawnPoint )
{
	foreach( grenade in level.grenades )
	{
		if( !isdefined( grenade ) )
			continue;
		
		if( DistanceSquared( spawnPoint.origin, grenade.origin) < CONST_EXPLOSIVE_RANGE_SQUARDED )
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
	
	return CONST_SCORE_FACTOR_MAX;
}



//===========================================
// 				avoidMines
//===========================================
avoidMines( spawnPoint )
{
	explosiveArray = combineArrays( level.mines, level.ims );
		
	foreach( explosive in explosiveArray )
	{
		if( !isdefined( explosive ) )
			continue;
		
		if( DistanceSquared( spawnPoint.origin, explosive.origin) < CONST_EXPLOSIVE_RANGE_SQUARDED )
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
	
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 		avoidAirStrikeLocations
//===========================================
avoidAirStrikeLocations( spawnPoint )
{
	if( !isDefined( level.artilleryDangerCenters ) )
		return CONST_SCORE_FACTOR_MAX;
	
	// spawn points located inside are good
	if( !spawnPoint.outside )
		return CONST_SCORE_FACTOR_MAX;
	
	// 0 = none, 1 = full, might be > 1 for more than 1 airstrike
	airstrikeDanger = maps\mp\killstreaks\_airstrike::getAirstrikeDanger( spawnPoint.origin ); 
		
	if( airstrikeDanger > 0 )
	{
		return CONST_SCORE_FACTOR_MIN;
	}
	
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 			avoidVisibleEnemies
//===========================================
avoidVisibleEnemies( spawnPoint )
{
	enemyTeams = [];
	
	if( level.teambased )
	{
		enemyTeams = getEnemyTeams( self.team );
	}
	else
	{
		enemyTeams[enemyTeams.size] = "all";
	}
	
	foreach( enemyTeam in enemyTeams )
	{
		if( spawnPoint.sights[enemyTeam] > 0 )
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
	
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 				getEnemyTeams
//===========================================
getEnemyTeams( team )
{
	enemyTeams = [];
	
	foreach( teamName in level.teamNameList )
	{
		if( teamName != team )
		{
			enemyTeams[enemyTeams.size] = teamName;
		}
	}
	
	return enemyTeams;
}


//===========================================
// 				avoidTelefrag
//===========================================
avoidTelefrag( spawnPoint )
{
	if( isDefined( self.allowTelefrag ) )
		return CONST_SCORE_FACTOR_MAX;
	
	if( PositionWouldTelefrag( spawnPoint.origin ) )
	{
		foreach( alternate in spawnpoint.alternates )
		{
			if( !PositionWouldTelefrag( alternate ) )
			{
				break;
			}
		}
		
		return CONST_SCORE_FACTOR_MIN; 
	}
	
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 			avoidSameSpawn
//===========================================
avoidSameSpawn( spawnPoint )
{
	if( IsDefined( self.lastspawnpoint ) && ( self.lastspawnpoint == spawnPoint ) )
	{
		return CONST_SCORE_FACTOR_MIN;
	}
		
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 			avoidEnemySpawn
//===========================================
avoidEnemySpawn( spawnPoint )
{
	// the enemy team was the last team to use this spawn point
	if( IsDefined( spawnpoint.lastspawnteam ) && ( !level.teamBased || (spawnpoint.lastspawnteam != self.team) ) )
	{
		allowSpawnTime = spawnpoint.lastspawntime + CONST_ENEMY_SPAWN_TIME_LIMIT;
		
		if( GetTime() < allowSpawnTime )
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
		
	return CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 			avoidLastDeathLocation
//===========================================
avoidLastDeathLocation( spawnPoint )
{
	if( !isDefined( self.lastDeathPos ) )
	{
	   	return CONST_SCORE_FACTOR_MAX;
	}
	
	distsq = DistanceSquared( spawnpoint.origin, self.lastDeathPos );
	
	if( distsq > CONST_REVENGE_DISTANCE_SQUARED )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
	
	// high distance away is good
	percentDist = ( distsq / CONST_REVENGE_DISTANCE_SQUARED );
		
	return percentDist * CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 			avoidLastAttackerLocation
//===========================================
avoidLastAttackerLocation( spawnPoint )
{
	if ( !isDefined( self.lastAttacker ) || !isDefined( self.lastAttacker.origin ) )
	{
	   	return CONST_SCORE_FACTOR_MAX;
	}
	
	distsq = DistanceSquared( spawnpoint.origin, self.lastAttacker.origin );
	
	if( distsq > CONST_REVENGE_DISTANCE_SQUARED )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
	
	// high distance away is good
	percentDist = ( distsq / CONST_REVENGE_DISTANCE_SQUARED );
		
	return percentDist * CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 	 		preferAlliesByDistance
//===========================================
preferAlliesByDistance( spawnPoint )
{
	// no teammates where alive when this spawn point updated
	if( spawnpoint.totalPlayers[ self.team ] == 0 )
	{
		return CONST_SCORE_FACTOR_MIN;
	}
	
	// average ally distance away from spawn point
	allyAverageDist = spawnPoint.distSum[self.team] / spawnpoint.totalPlayers[self.team];
	allyAverageDist = min( allyAverageDist, CONST_PLAYER_DISTANCE_MAX );
	
	// high ally distance is bad
	scoringPercentage = 1 - ( allyAverageDist / CONST_PLAYER_DISTANCE_MAX );
	
	return scoringPercentage * CONST_SCORE_FACTOR_MAX;
}
	
	
//===========================================
// 	   		avoidEnemiesByDistance
//===========================================
avoidEnemiesByDistance( spawnPoint )
{
	enemyTeams = [];
	activeEnemyTeams = [];
	
	if( level.teambased )
	{
		enemyTeams = getEnemyTeams( self.team );
	}
	else
	{
		enemyTeams[enemyTeams.size] = "all";
	}
	
	foreach( enemyTeam in enemyTeams )
	{
		// no enemies on this team were alive when this spawn point updated
		if( spawnpoint.totalPlayers[ enemyTeam ] == 0 )
		{
			continue;
		}
		
		activeEnemyTeams[activeEnemyTeams.size] = enemyTeam;
	}

	if( activeEnemyTeams.size == 0 )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
	
	// there is an enemy in close proximity
	foreach( enemyTeam in activeEnemyTeams )
	{
		if( spawnpoint.minDist[enemyTeam] < CONST_NEARBY_DISTANCE)
		{
			return CONST_SCORE_FACTOR_MIN;
		}
	}
	
	totalDistance 	= 0;
	totalEnemies 	= 0;
	
	foreach( enemyTeam in activeEnemyTeams )
	{
		totalDistance 	+= spawnPoint.distSum[enemyTeam];
		totalEnemies 	+= spawnpoint.totalPlayers[enemyTeam];
	}
	
	// average enemy distance away from spawn point
	enemeyAverageDist = totalDistance / totalEnemies;
	
	// high enemy distance is good
	enemeyAverageDist = min( enemeyAverageDist, CONST_PLAYER_DISTANCE_MAX );
	scoringPercentage = ( enemeyAverageDist / CONST_PLAYER_DISTANCE_MAX );	
	
	return scoringPercentage * CONST_SCORE_FACTOR_MAX;
}


//===========================================
// 	   			preferDomPoints
//===========================================
preferDomPoints( spawnPoint, perferdDomPointArray )
{
	if( perferdDomPointArray[0] && spawnPoint.domPointA )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
	
	if( perferdDomPointArray[1] && spawnPoint.domPointB )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
		
	if( perferdDomPointArray[2] && spawnPoint.domPointC )
	{
		return CONST_SCORE_FACTOR_MAX;
	}
	
	return CONST_SCORE_FACTOR_MIN;
}