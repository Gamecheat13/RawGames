#include maps\mp\gametypes\_spawnfactor;
#include common_scripts\utility;

//===========================================
// 			getSpawnpoint_NearTeam
//===========================================
getSpawnpoint_NearTeam( spawnPoints )
{
	spawnPoints = checkDynamicSpawns( spawnPoints );
	bestSpawn 	= spawnPoints[0];
	
	foreach( spawnPoint in spawnPoints )
	{
		initScoreData( spawnPoint );

		// spawn points must pass all critical factors to be selected
		if( !criticalFactors_NearTeam( spawnPoint ) )
		{
/#
			// calculates the total score of the spawn point, I want to know what it would have been...
			scoreFactors_NearTeam( spawnPoint );
			spawnPoint.totalScore = 0; // reset it back to not usable, I don't want to change behavior...
#/
			continue;
		}
	
		// calculates the total score of the spawn point
		scoreFactors_NearTeam( spawnPoint );
		
		// select the spawn point with the largest score
		if( spawnPoint.totalScore > bestSpawn.totalScore )
		{
			bestSpawn = spawnPoint;
		}
	}
	
	bestSpawn = selectBestSpawnPoint( bestSpawn, spawnPoints );
	
	/#
	foundIt = 0;
	foreach ( spawn in level.spawnLogData )
	{
		if ( spawn == bestSpawn )
		{
			foundIt = 1;
		}
	}
	
	if ( foundIt == 0 )
		level.spawnLogData[level.spawnLogData.size] = bestSpawn;
		
	if ( !isDefined( bestSpawn.spawnCount ) )
	{
		bestSpawn.spawnCount = 1;
	}
	
	if (isdefined(self.isspawning) && self.isspawning)
	{
		self.spawnpoints = spawnpoints;
		if ( IsDefined(bestSpawn.buddySpawn) && bestSpawn.buddySpawn )
			self.spawnpoints[self.spawnpoints.size] = bestSpawn;
		self.resultspawnpoint = bestSpawn;
	}
	#/
	
	return bestSpawn;
}


//============================================
// 			checkDynamicSpawns
//============================================
checkDynamicSpawns( spawnPoints )
{
	// a function callback that allows level script to adjust spawn points dynamically based on level specific events
	if( isDefined( level.dynamicSpawns ) )
	{
		spawnPoints = [[level.dynamicSpawns]]( spawnPoints );
	}
	
	return spawnPoints;
}


//============================================
// 			selectBestSpawnPoint
//============================================
selectBestSpawnPoint( highestScoringSpawn, spawnPoints )
{
	bestSpawn = highestScoringSpawn;
	numberOfPossibleSpawnChoices = 0;
	self.resultCode = 1;
	self.lastMinuteSightTracesFailed = 0;
	
	// calcualte the number of available spawns
	foreach( spawnPoint in spawnPoints )
	{
		if( spawnPoint.totalScore > 0 )
		{
			numberOfPossibleSpawnChoices++;
		}
	}
		
	// there are enough good spawns to safely apply additional spawn selection logic
	if( numberOfPossibleSpawnChoices > 3 )
	{
		// if the best spawn point was the last spawn point, find the second best spawn point
		if( IsDefined( self.lastspawnpoint ) && ( bestSpawn == self.lastspawnpoint ) )
		{
			bestSpawn = findSecondHighestSpawnScore( highestScoringSpawn, spawnPoints );
			self.resultCode = 2;
		}
	}
		
	// not enough avaliable spawns to guarantee a good spawn
	if( ( numberOfPossibleSpawnChoices == 0 ) || level.forceBuddySpawn )
	{
		// try to spawn on a buddy
		if( level.teamBased )
		{
			teamSpawnPoint = findBuddySpawn();
			
			if( teamSpawnPoint.buddySpawn )
			{
				bestSpawn = teamSpawnPoint;
				self.resultCode = 3;
			}
		}
		
		// if all spawn points are bad, pick randomly
		if( bestSpawn.totalScore == 0 )
		{
			bestSpawn = spawnPoints[RandomInt( spawnPoints.size )];
			self.resultCode = 4;
		}
	}
	
	/#
	bestSpawn.numberOfPossibleSpawnChoices = numberOfPossibleSpawnChoices;
	
	
	activePlayerArray = maps\mp\gametypes\_spawnlogic::getActivePlayerArray( false );
	foreach ( player in activePlayerArray )
	{
		playerHeight = maps\mp\gametypes\_spawnlogic::getPlayerTraceHeight( player );
	
		if ( player.team != self.team )
		{
			sightValue = SpawnSightTrace( bestSpawn, bestSpawn.origin + (0,0,playerHeight), player.origin + (0,0,playerHeight) );
			if ( sightValue > 0 )
			{
				self.lastMinuteSightTracesFailed++;
			}
		}
	}
	#/
		
	if ( IsDefined( bestSpawn.dropToGround ) )
	{
		bestSpawn.origin = DropToGround( bestSpawn.origin );
		bestSpawn.dropToGround = undefined;
	}
	
	return bestSpawn;
}


//============================================
// 		 	findSecondHighestSpawnScore
//============================================
findSecondHighestSpawnScore( highestScoringSpawn, spawnPoints )
{
	bestSpawn = spawnPoints[0];
	
	// exclude the highest scoring spawn
	if( bestSpawn == highestScoringSpawn )
	{
		bestSpawn = spawnPoints[1];
	}
	
	foreach( spawnPoint in spawnPoints )
	{
		// exclude the highest scoring spawn
		if( spawnPoint == highestScoringSpawn )
		{
			continue;
		}
		
		// select the spawn point with the largest score
		if( spawnPoint.totalScore > bestSpawn.totalScore )
		{
			bestSpawn = spawnPoint;
		}
	}
	
	return bestSpawn;
}


//============================================
// 				findBuddySpawn
//============================================
findBuddySpawn()
{
	spawnLocation = SpawnStruct();
	initScoreData( spawnLocation );
	
	teamMates = getTeamMatesOutOfCombat( self.team );
	
	trace = SpawnStruct();
	trace.maxTraceCount = 18;
	trace.currentTraceCount = 0;
	
	foreach( player in teamMates )
	{
		location = findSpawnLocationNearPlayer( player );
		
		if( !IsDefined( location ) )
		{
			continue;
		}
		
		if( isSafeToSpawnOn( player, location, trace ) )
		{
			spawnLocation.totalScore 	= 999;
			spawnLocation.buddySpawn	= true;
			spawnLocation.origin 		= location;
			spawnLocation.angles		= getBuddySpawnAngles( player, spawnLocation.origin );
			break;
		}
		
		if( trace.currentTraceCount == trace.maxTraceCount )
		{
			break;
		}
	}
	
	return spawnLocation;
}


//============================================
// 			getBuddySpawnAngles
//============================================
getBuddySpawnAngles( buddy, spawnLocation )
{
	// start with the buddy's angles
	spawnAngles = ( 0, buddy.angles[1], 0 );
	
	entranceNodes = FindEntrances( spawnLocation );
	
	// pick an angle that faces an entrace
	if( IsDefined(entranceNodes) && (entranceNodes.size > 0) )
	{
		spawnAngles = VectorToAngles( entranceNodes[0].origin - spawnLocation );
	}
	
	return spawnAngles;
}


//============================================
// 			getTeamMatesOutOfCombat
//============================================
getTeamMatesOutOfCombat( team )
{
	teamMates = [];
	
	foreach( player in level.players )
	{
		// only find teammates
		if( player.team != team )
		{
			continue;
		}
		
		// only find active teammates
		if( player.sessionstate != "playing" )
		{
			continue;
		}
		
		if( player == self )
		{
			continue;
		}
		
		// only find players not in combat
		if( isPlayerInCombat( player ) )
		{
			continue;
		}
		
		teamMates[teamMates.size] = player;
	}

	return array_randomize( teamMates );
}


//============================================
// 			isPlayerInCombat
//============================================
isPlayerInCombat( player )
{
	// player must be on the ground
	if( !player IsOnGround() )
	{
		return true;
	}
	
	if( player IsOnLadder() )
	{
		return true;
	}
	
	if( player isFlashed() )
	{
		return true;
	}
	
	// player must be at max health
	if( player.health < player.maxhealth )
	{
		return true;
	}
	
	// player cannot be near any grenades
	if( !avoidGrenades( player ) )
	{
		return true;
	}
	
	// player cannot be near any explosives
	if( !avoidMines( player ) )
	{
		return true;
	}
	
	return false;
}


//============================================
// 			findSpawnLocationNearPlayer
//============================================
findSpawnLocationNearPlayer( player )
{
	playerHeight = maps\mp\gametypes\_spawnlogic::getPlayerTraceHeight( player, true );
	
	// try to find a path node near the buddy to use as a valid spawn location
	buddyNode = findBuddyPathNode( player, playerHeight );
	
	if( IsDefined( buddyNode ) )
	{
		return buddyNode.origin;
	}
	
	// there was not a valid path node, time for math :(
	rightVector		= anglesToRight( player.angles );
	playerOffset	= rightVector * 45;
	spawnPointRight = player.origin + playerOffset;
	spawnPointLeft 	= player.origin - playerOffset;
	
	finalSpawnLocation = validateBuddySpawnLocation( player, spawnPointRight, playerHeight );
	
	if( IsDefined( finalSpawnLocation ) )
	{
		return finalSpawnLocation;
	}
	
	return validateBuddySpawnLocation( player, spawnPointLeft, playerHeight );
}


//============================================
// 			findBuddyPathNode
//============================================
findBuddyPathNode( buddy, playerHeight )
	{
	nodeArray 	= GetNodesInRadiusSorted( buddy.origin,  64, 32, playerHeight, "Path" );
	bestNode 	= undefined;
	
	if( IsDefined(nodeArray) && nodeArray.size > 0 )
	{
		buddyDir = AnglesToForward( buddy.angles );
		
		// loop to find a node that is not in the player's current view
		foreach( buddyNode in nodeArray )
		{
			directionToNode = VectorNormalize( buddyNode.origin - buddy.origin );
			dot = VectorDot( buddyDir, directionToNode );
			
			// the node is not in the player's view ( cos 45 = 0.525 )
			if( (dot < 0.525) && !positionWouldTelefrag( buddyNode.origin ) )
			{
				bestNode = buddyNode;
				break;
			}
	}
	}
	
	return bestNode;
}

	
//============================================
// 		validateBuddySpawnLocation
//============================================
validateBuddySpawnLocation( buddy, buddySpawnLocation, playerHeight )
{
	// trace from the buddy to the buddySpawnLocation at head level 
	// this check ensures players do not buddy spawn on the opposite side of a wall  
	if( !sightTracePassed( buddy.origin + (0,0,playerHeight), buddySpawnLocation + (0,0,playerHeight), false, buddy ) )
	{
	return undefined;
}

	// trace stright down to find the ground location
	// adding 30 to traceStart to account for terrain height changes 
	traceStart 	= buddySpawnLocation + (0, 0, playerHeight + 30 );
	traceEnd 	= buddySpawnLocation - (0, 0, playerHeight);
	traceData 	= BulletTrace( traceStart, traceEnd, false );
	
	// the trace did not hit the ground
	// this prevents buddy spawning in mid air 
	if( traceData["fraction"] == 1 )
	{
		return undefined;
	}

	// adding 5 to the groundLocation to prevent canSpawn from starting the trace while touching the ground
	groundLocation 		= traceData["position"] + ( 0, 0, 5 );
	avalibleRoomSquared = DistanceSquared( traceStart, groundLocation );
		
	// ensure there is enough room to spawn the player
	if( avalibleRoomSquared < (playerHeight * playerHeight) )
	{
		return undefined;
	}
		
	if( positionWouldTelefrag( groundLocation ) || !canSpawn( groundLocation ) )
	{
		return undefined;
	}
	
	return groundLocation;
}


//============================================
// 			isSafeToSpawnOn
//============================================
isSafeToSpawnOn( teamMember, pointToSpawnCheck, trace )
{
	if( teamMember IsSighted() )
	{
		return false;
	}
	
	visibleEnemies = teamMember GetPlayersSightingMe();
	
	if( IsDefined( visibleEnemies ) && (visibleEnemies.size > 1) )
	{
		return false;
	}
	
	// ahodge TODO:: the below script needs a code solution that leverages the eyes on data
	
	foreach( player in level.players )
	{
		if( trace.currentTraceCount == trace.maxTraceCount )
		{
			return false;
		}
				
		if( player.team == self.team )
		{
			continue;
		}
		
		if( player.sessionstate != "playing" )
		{
			continue;
		}
		
		if( player == self )
		{
			continue;
		}
		
		trace.currentTraceCount++;
		playerHeight = maps\mp\gametypes\_spawnlogic::getPlayerTraceHeight( player );
		
		if( sightTracePassed( pointToSpawnCheck + (0,0,playerHeight), player.origin + (0,0,playerHeight), false, self, player ) )
		{
			return false;
		}
	}
	
	return true;	
}


//===========================================
// 			initScoreData
//===========================================
initScoreData( spawnPoint )
{
	spawnPoint.totalScore = 0;
	spawnPoint.numberOfPossibleSpawnChoices = 0;
	
	/#
	spawnPoint.debugScoreData = [];
	spawnPoint.debugCriticalData = [];
	spawnPoint.debugCriticalBitfield = 0;
	spawnPoint.totalPossibleScore = 0;
	spawnPoint.buddySpawn = false;
	#/
}


//===========================================
// 			criticalFactors_NearTeam
//===========================================
criticalFactors_NearTeam( spawnPoint )
{
	temporaryVariable = true;
/#
	temporaryVariable = false;
#/
		
	// never spawn with line of sight to an enemy
	if( !critical_factor( ::avoidVisibleEnemies, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 0);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn on top of a grenade
	if( !critical_factor( ::avoidGrenades, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 1);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn on top of a mine/claymore
	if( !critical_factor( ::avoidMines, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 2);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn on an airstrike location
	if( !critical_factor( ::avoidAirStrikeLocations, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 3);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn on top of a care package
	if( !critical_factor( ::avoidCarePackages, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 4);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn inside another player
	if( !critical_factor( ::avoidTelefrag, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 5);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	// never spawn at a point where an enemy just spawned
	if( !critical_factor( ::avoidEnemySpawn, spawnPoint ) )
	{
/#
		spawnPoint.debugCriticalBitfield += (1 << 6);
#/
		if ( temporaryVariable )
		{
			return false;
		}
	}
	
	return temporaryVariable || !spawnPoint.debugCriticalBitfield;
}


//===========================================
// 			scoreFactors_NearTeam
//===========================================
scoreFactors_NearTeam( spawnPoint )
{
	// perfer nearby teammates
	scoreFactor = score_factor( 1.5, ::preferAlliesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid nearby enemies
	scoreFactor = score_factor( 1.0, ::avoidEnemiesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last death location
	scoreFactor = score_factor( 0.25, ::avoidLastDeathLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last attacker
	scoreFactor = score_factor( 0.25, ::avoidLastAttackerLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid choosing the same spawn twice in a row
	scoreFactor = score_factor( 0.25, ::avoidSameSpawn, spawnPoint );
	spawnPoint.totalScore += scoreFactor;

/#
	spawnpoint.weight_allyDistance = spawnpoint.debugScoreData[0];
	spawnpoint.weight_enemyDistance = spawnpoint.debugScoreData[1];
	spawnpoint.weight_avoidDeathLoc = spawnpoint.debugScoreData[2];
	spawnpoint.weight_avoidKillerLoc = spawnpoint.debugScoreData[3];
	spawnpoint.weight_avoidSameSpawn = spawnpoint.debugScoreData[4];
#/
}


//===========================================
// 		  getSpawnpoint_Domination
//===========================================
getSpawnpoint_Domination( spawnPoints, perferdDomPointArray )
{
	spawnPoints = checkDynamicSpawns( spawnPoints );
	bestSpawn 	= spawnPoints[0];
	
	foreach( spawnPoint in spawnPoints )
	{
		initScoreData( spawnPoint );

		// spawn points must pass all critical factors to be selected
		if( !criticalFactors_Domination( spawnPoint ) )
		{
			continue;
		}
	
		// calculates the total score of the spawn point
		scoreFactors_Domination( spawnPoint, perferdDomPointArray );
		
		// select the spawn point with the largest score
		if( spawnPoint.totalScore > bestSpawn.totalScore )
		{
			bestSpawn = spawnPoint;
		}
	}
	
	bestSpawn = selectBestSpawnPoint( bestSpawn, spawnPoints );
	
	/#
	foundIt = 0;
	foreach ( spawn in level.spawnLogData )
	{
		if ( spawn == bestSpawn )
		{
			foundIt = 1;
		}
	}
	
	if ( foundIt == 0 )
		level.spawnLogData[level.spawnLogData.size] = bestSpawn;
		
	if ( !isDefined( bestSpawn.spawnCount ) )
	{
		bestSpawn.spawnCount = 1;
	}
	
	if (isdefined(self.isspawning) && self.isspawning)
	{
		self.spawnpoints = spawnpoints;
		if ( IsDefined(bestSpawn.buddySpawn) && bestSpawn.buddySpawn )
			self.spawnpoints[self.spawnpoints.size] = bestSpawn;
		self.resultspawnpoint = bestSpawn;
	}
	#/

	return bestSpawn;
}


//===========================================
// 		criticalFactors_Domination
//===========================================
criticalFactors_Domination( spawnPoint )
{
	return criticalFactors_NearTeam( spawnPoint );
}


//===========================================
// 		scoreFactors_Domination
//===========================================
scoreFactors_Domination( spawnPoint, perferdDomPointArray )
{
	// prefer spawns near dom points
	scoreFactor = score_factor( 1.5, ::preferDomPoints, spawnPoint, perferdDomPointArray );
	spawnPoint.totalScore += scoreFactor;
	
	// perfer nearby teammates
	scoreFactor = score_factor( 1.0, ::preferAlliesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid nearby enemies
	scoreFactor = score_factor( 1.0, ::avoidEnemiesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last death location
	scoreFactor = score_factor( 0.25, ::avoidLastDeathLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last attacker
	scoreFactor = score_factor( 0.25, ::avoidLastAttackerLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid choosing the same spawn twice in a row
	scoreFactor = score_factor( 0.25, ::avoidSameSpawn, spawnPoint );
	spawnPoint.totalScore += scoreFactor;

/#
	spawnpoint.weight_domPoints = spawnpoint.debugScoreData[0];
	spawnpoint.weight_allyDistance = spawnpoint.debugScoreData[1];
	spawnpoint.weight_enemyDistance = spawnpoint.debugScoreData[2];
	spawnpoint.weight_avoidDeathLoc = spawnpoint.debugScoreData[3];
	spawnpoint.weight_avoidKillerLoc = spawnpoint.debugScoreData[4];
	spawnpoint.weight_avoidSameSpawn = spawnpoint.debugScoreData[5];
#/
}


//===========================================
// 		getSpawnpoint_FreeForAll
//===========================================
getSpawnpoint_FreeForAll( spawnpoints )
{
	spawnPoints = checkDynamicSpawns( spawnPoints );
	bestSpawn 	= spawnPoints[0];
	
	foreach( spawnPoint in spawnPoints )
	{
		initScoreData( spawnPoint );

		// spawn points must pass all critical factors to be selected
		if( !criticalFactors_FreeForAll( spawnPoint ) )
		{
			continue;
		}
	
		// calculates the total score of the spawn point
		scoreFactors_FreeForAll( spawnPoint );
		
		// select the spawn point with the largest score
		if( spawnPoint.totalScore > bestSpawn.totalScore )
		{
			bestSpawn = spawnPoint;
		}
	}
	
	bestSpawn = selectBestSpawnPoint( bestSpawn, spawnPoints );
	
	/#
	foundIt = 0;
	foreach ( spawn in level.spawnLogData )
	{
		if ( spawn == bestSpawn )
		{
			foundIt = 1;
		}
	}
	
	if ( foundIt == 0 )
		level.spawnLogData[level.spawnLogData.size] = bestSpawn;
		
	if ( !isDefined( bestSpawn.spawnCount ) )
	{
		bestSpawn.spawnCount = 1;
	}
	
	if (isdefined(self.isspawning) && self.isspawning)
	{
		self.spawnpoints = spawnpoints;
		if ( IsDefined(bestSpawn.buddySpawn) && bestSpawn.buddySpawn )
			self.spawnpoints[self.spawnpoints.size] = bestSpawn;
		self.resultspawnpoint = bestSpawn;
	}
	#/

	return bestSpawn;
}


//===========================================
// 		criticalFactors_FreeForAll
//===========================================
criticalFactors_FreeForAll( spawnPoint )
{
	return criticalFactors_NearTeam( spawnPoint );
}


//===========================================
// 		scoreFactors_FreeForAll
//===========================================
scoreFactors_FreeForAll( spawnPoint )
{	
	// avoid nearby enemies
	scoreFactor = score_factor( 2.0, ::avoidEnemiesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last death location
	scoreFactor = score_factor( 0.5, ::avoidLastDeathLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last attacker
	scoreFactor = score_factor( 0.5, ::avoidLastAttackerLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid choosing the same spawn twice in a row
	scoreFactor = score_factor( 0.5, ::avoidSameSpawn, spawnPoint );
	spawnPoint.totalScore += scoreFactor;

/#
	spawnpoint.weight_enemyDistance = spawnpoint.debugScoreData[0];
	spawnpoint.weight_avoidDeathLoc = spawnpoint.debugScoreData[1];
	spawnpoint.weight_avoidKillerLoc = spawnpoint.debugScoreData[2];
	spawnpoint.weight_avoidSameSpawn = spawnpoint.debugScoreData[3];
#/
}


//===========================================
// 		getSpawnpoint_SearchAndRescue
//===========================================
getSpawnpoint_SearchAndRescue( spawnPoints )
{
	spawnPoints = checkDynamicSpawns( spawnPoints );
	bestSpawn 	= spawnPoints[0];
	
	foreach( spawnPoint in spawnPoints )
	{
		initScoreData( spawnPoint );

		// spawn points must pass all critical factors to be selected
		if( !criticalFactors_SearchAndRescue( spawnPoint ) )
		{
			continue;
		}
	
		// calculates the total score of the spawn point
		scoreFactors_SearchAndRescue( spawnPoint );
		
		// select the spawn point with the largest score
		if( spawnPoint.totalScore > bestSpawn.totalScore )
		{
			bestSpawn = spawnPoint;
		}
	}
	
	bestSpawn = selectBestSpawnPoint( bestSpawn, spawnPoints );
	
	/#
	foundIt = 0;
	foreach ( spawn in level.spawnLogData )
	{
		if ( spawn == bestSpawn )
		{
			foundIt = 1;
		}
	}
	
	if ( foundIt == 0 )
		level.spawnLogData[level.spawnLogData.size] = bestSpawn;
		
	if ( !isDefined( bestSpawn.spawnCount ) )
	{
		bestSpawn.spawnCount = 1;
	}
	
	if (isdefined(self.isspawning) && self.isspawning)
	{
		self.spawnpoints = spawnpoints;
		if ( IsDefined(bestSpawn.buddySpawn) && bestSpawn.buddySpawn )
			self.spawnpoints[self.spawnpoints.size] = bestSpawn;
		self.resultspawnpoint = bestSpawn;
	}
	#/

	return bestSpawn;
}


//===========================================
// 		criticalFactors_SearchAndRescue
//===========================================
criticalFactors_SearchAndRescue( spawnPoint )
{
	return criticalFactors_NearTeam( spawnPoint );
}


//===========================================
// 		scoreFactors_SearchAndRescue
//===========================================
scoreFactors_SearchAndRescue( spawnPoint )
{	
	// avoid nearby enemies
	scoreFactor = score_factor( 2.0, ::avoidEnemiesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// perfer nearby teammates
	scoreFactor = score_factor( 1.0, ::preferAlliesByDistance, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last death location
	scoreFactor = score_factor( 0.5, ::avoidLastDeathLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;
	
	// avoid spawning near your last attacker
	scoreFactor = score_factor( 0.5, ::avoidLastAttackerLocation, spawnPoint );
	spawnPoint.totalScore += scoreFactor;

/#
	spawnpoint.weight_enemyDistance = spawnpoint.debugScoreData[0];
	spawnpoint.weight_allyDistance = spawnpoint.debugScoreData[1];
	spawnpoint.weight_avoidDeathLoc = spawnpoint.debugScoreData[2];
	spawnpoint.weight_avoidKillerLoc = spawnpoint.debugScoreData[3];
#/
}