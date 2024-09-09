#include common_scripts\utility;
#include maps\mp\_utility;


//============================================
// 		 	setMapCenterForDev
//============================================
setMapCenterForDev()
{
	level.spawnMins = (0,0,0);
	level.spawnMaxs = (0,0,0);
	
	maps\mp\gametypes\_spawnlogic::expandSpawnpointBounds( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::expandSpawnpointBounds( "mp_tdm_spawn_axis_start" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


//============================================
// 		 	expandSpawnpointBounds
//============================================
expandSpawnpointBounds( classname )
{
	spawnPoints = getSpawnpointArray( classname );
	for( index = 0; index < spawnPoints.size; index++ )
	{
		level.spawnMins = expandMins( level.spawnMins, spawnPoints[index].origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, spawnPoints[index].origin );
	}
}


//============================================
// 		 		expandMins
//============================================
expandMins( mins, point )
{
	if ( mins[0] > point[0] )
		mins = ( point[0], mins[1], mins[2] );
	if ( mins[1] > point[1] )
		mins = ( mins[0], point[1], mins[2] );
	if ( mins[2] > point[2] )
		mins = ( mins[0], mins[1], point[2] );
	return mins;
}


//============================================
// 		 		expandMaxs
//============================================
expandMaxs( maxs, point )
{
	if ( maxs[0] < point[0] )
		maxs = ( point[0], maxs[1], maxs[2] );
	if ( maxs[1] < point[1] )
		maxs = ( maxs[0], point[1], maxs[2] );
	if ( maxs[2] < point[2] )
		maxs = ( maxs[0], maxs[1], point[2] );
	return maxs;
}


//============================================
// 		 		findBoxCenter
//============================================
findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}


//============================================
// 		 	addStartSpawnPoints
//============================================
addStartSpawnPoints( spawnPointName )
{
	spawnPoints = getSpawnpointArray( spawnPointName );
		
	if( !spawnPoints.size )
	{
		println( "^1Error: No " + spawnPointName + " spawnpoints found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		wait( 1.0 );
		return;
	}
	
	if( !isDefined(level.startSpawnPoints) )
	{
		level.startSpawnPoints = [];
	}

	for( index = 0; index < spawnPoints.size; index++ )
	{
		spawnPoints[index] spawnPointInit();
		level.startSpawnPoints[ level.startSpawnPoints.size ] = spawnPoints[index];
	}
}


//============================================
// 		 		addSpawnPoints
//============================================
addSpawnPoints( team, spawnPointName, isSetOptional )
{
	if( !isDefined(level.spawnpoints) )
	{
		level.spawnpoints = [];
	}
	
	if( !isDefined(level.teamSpawnPoints[team]) )
	{
		level.teamSpawnPoints[team] = [];
	}
		
	if( !isDefined( isSetOptional ) )
	{
		isSetOptional = false;
	}
	
	// grab the new spawn points
	newSpawnPoints = [];
	newSpawnPoints = getSpawnpointArray( spawnPointName );
	
	if( !newSpawnPoints.size && !isSetOptional )
	{
		println( "^1Error: No " + spawnPointName + " spawnpoints found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		wait( 1.0 );
		return;
	}
	
	// initialize and save the new spawns
	foreach( spawnPoint in newSpawnPoints )
	{
		if( !isdefined( spawnpoint.inited ) )
		{
			spawnpoint spawnPointInit();
			level.spawnpoints[ level.spawnpoints.size ] = spawnpoint;
		}
		
		// different teams can share the same spawn point 
		level.teamSpawnPoints[team][ level.teamSpawnPoints[team].size ] = spawnPoint;
	}
}


//============================================
// 		 		spawnPointInit
//============================================
spawnPointInit()
{
	spawnpoint = self;
	
	level.spawnMins = expandMins( level.spawnMins, spawnpoint.origin );
	level.spawnMaxs = expandMaxs( level.spawnMaxs, spawnpoint.origin );
	
	spawnpoint.forward 			= anglesToForward( spawnpoint.angles );
	spawnpoint.sightTracePoint 	= spawnpoint.origin + (0,0,50);
	spawnpoint.lastspawntime 	= gettime();
	spawnpoint.outside 			= true;
	spawnpoint.inited 			= true;
	spawnpoint.alternates 		= [];
	
	skyHeight = 1024;

	if( !bullettracepassed( spawnpoint.sightTracePoint, spawnpoint.sightTracePoint + (0,0,skyHeight), false, undefined ) )
	{
		startpoint = spawnpoint.sightTracePoint + spawnpoint.forward * 100;
		if( !bullettracepassed( startpoint, startpoint + (0,0,skyHeight), false, undefined ) )
		{
			spawnpoint.outside = false;
		}
	}
	
	right = anglesToRight( spawnpoint.angles );
	
	AddAlternateSpawnpoint( spawnpoint, spawnpoint.origin + right * 45 );
	AddAlternateSpawnpoint( spawnpoint, spawnpoint.origin - right * 45 );
	
	spawnPointUpdate( spawnpoint );
}


//============================================
// 		 	AddAlternateSpawnpoint
//============================================
AddAlternateSpawnpoint( spawnpoint, alternatepos )
{
	spawnpointposRaised = playerPhysicsTrace( spawnpoint.origin, spawnpoint.origin + (0,0,18) );
	zdiff = spawnpointposRaised[2] - spawnpoint.origin[2];
	
	alternateposRaised = (alternatepos[0], alternatepos[1], alternatepos[2] + zdiff );
	
	traceResult = playerPhysicsTrace( spawnpointposRaised, alternateposRaised );
	if ( traceResult != alternateposRaised )
		return;
	
	finalAlternatePos = playerPhysicsTrace( alternateposRaised, alternatepos );
	
	spawnpoint.alternates[ spawnpoint.alternates.size ] = finalAlternatePos;
}


//============================================
// 		 	getSpawnpointArray
//============================================
getSpawnpointArray( classname )
{
	if( !IsDefined(level.spawnPointArray) )
	{
		level.spawnPointArray = [];
	}
	
	if( !IsDefined(level.spawnPointArray[classname]) )
	{
		level.spawnPointArray[classname] = [];
		level.spawnPointArray[classname] = getSpawnArray( classname );
		
		foreach( spawnPoint in level.spawnPointArray[classname] )
		{
			spawnPoint.classname = classname;
		}
	}
	
	return level.spawnPointArray[classname];
}


//============================================
// 		 	getSpawnpoint_Random
//============================================
getSpawnpoint_Random( spawnPoints )
{
	if( !IsDefined( spawnPoints ) )
	{
		return undefined;
	}

	randomSpawnPoint 	= undefined;
 	spawnPoints 		= array_randomize( spawnPoints );
	
	// select the first valid spawn point
	foreach( spawnPoint in spawnPoints )
	{
		randomSpawnPoint = spawnPoint;
		
		if( CanSpawn( randomSpawnPoint.origin ) && !PositionWouldTelefrag( randomSpawnPoint.origin ) )
		{
			break;
		}
	}
	
	return randomSpawnPoint;
}


//============================================
// 		 	getSpawnpoint_NearTeam
//============================================
getSpawnpoint_NearTeam( spawnpoints, favoredspawnpoints )
{
	assertMsg( "game mode not supported by the new spawning system" );
	
	while( true )
	{
		wait( 5 );
	}
}


//============================================
// 		 		init
//============================================
init()
{
	level.killstreakSpawnShield = 5000;
	level.forceBuddySpawn = 0;
	level.spawnMins = (0,0,0);
	level.spawnMaxs = (0,0,0);
	
	/#
	level.debugSpawning = 0;
	#/

	level.players 			= [];
	level.spawnPointArray 	= [];
	level.grenades 			= [];
	level.missiles			= [];
	level.carePackages		= [];
	level.helis 			= [];
	level.turrets 			= [];
	level.tanks 			= [];
	level.scramblers 		= [];
	level.ims 				= [];
	level.ugvs 				= [];
	level.ballDrones 		= [];
	
	level thread trackGrenades();
	level thread trackMissiles();
	level thread trackCarePackages();

	for( i = 0; i < level.teamNameList.size; i++ )
	{
		level.teamSpawnPoints[level.teamNameList[i]] = [];
	}
	
	// DEBUG
	/#
	thread spawnInfoWriter();
	level.spawnLogData = [];
	#/
}


//============================================
// 		 		trackGrenades
//============================================
trackGrenades()
{
	while( true )
	{
		level.grenades = getentarray("grenade", "classname");
		wait( 0.05 );
	}
}


//============================================
// 		 		trackMissiles
//============================================
trackMissiles()
{
	while( true )
	{
		level.missiles = getentarray( "rocket", "classname" );
		wait( 0.05 );
	}
}


//============================================
// 		 	trackCarePackages
//============================================
trackCarePackages()
{
	while( true )
	{
		level.carePackages = getEntArray( "care_package", "targetname" );
		wait( 0.05 );
	}
}


//===========================================
// 			getTeamSpawnPoints
//===========================================
getTeamSpawnPoints( team )
{
	return level.teamSpawnPoints[team];
}


//===========================================
// 			isPathDataAvailable
//===========================================
isPathDataAvailable()
{
	if( !IsDefined( level.pathDataAvailable ) )
	{
		nodes = GetAllNodes();
		level.pathDataAvailable = ( IsDefined(nodes) && ( nodes.size > 150 ) );
	}
	
	return level.pathDataAvailable;
}


//============================================
// 			spawnPerFrameUpdate
//============================================
spawnPerFrameUpdate()
{
	if( !isDefined( level.spawnPoints ) )
	{
		return;
	}
		
	/#
	setDevDvarIfUninitialized( "scr_spawnpointdebug", "1" );
	setDevDvarIfUninitialized( "scr_forceBuddySpawn", "0" );
	#/
		
	while( true )
	{	
		spawnPoints = level.spawnPoints;
		spawnPoints = maps\mp\gametypes\_spawnscoring::checkDynamicSpawns( spawnPoints );
			
		// each frame, do sight checks against a spawnpoint
		foreach( spawnPoint in spawnPoints )
		{
			wait( 0.05 );
			
			/#
			level.debugSpawning 	= ( getdvarint("scr_spawnpointdebug") > 0 );
			level.forceBuddySpawn 	= ( getdvarint("scr_forceBuddySpawn") > 0 );
			#/
			
			if( !IsDefined( level.skipSpawnUpdate) || !level.skipSpawnUpdate )
			{
				spawnPointUpdate( spawnPoint );
			}
		}
	}
}


//============================================
// 			getActivePlayerArray
//============================================
getActivePlayerArray( useAgents )
{
	activePlayerArray = [];
	
	// find active players
	foreach( player in level.players )
	{
		if( player.sessionstate != "playing" )
		{
			continue;
		}
				
		activePlayerArray[activePlayerArray.size] = player;
	}
	
	// check for agents 
	if( !IsDefined(level.agentArray)
	   || ( IsDefined( useAgents ) && !useAgents ))
	{
		return activePlayerArray;
	}
	
	// find active agents
	foreach( agent in level.agentArray )
	{
		if( !agent.isActive )
		{
			continue;
		}
				
		activePlayerArray[activePlayerArray.size] = agent;
	}
	
	return activePlayerArray;
}


//============================================
// 			spawnPointUpdate
//============================================
spawnPointUpdate( spawnpoint )
{
	prof_begin( " spawn_update_init" );
	
	initSpawnPointValues( spawnpoint );

	currentTime = getTime();
	team = "all";
	spawnpoint.lastupdatetime = currentTime;
	
	activePlayerArray = getActivePlayerArray();
	
	foreach( player in activePlayerArray )
	{
		if( level.teambased )
		{
			team = player.team;
		}
		
		// calculate distance between the player and the spawn point
		dist = Distance( player.origin, spawnpoint.origin );
		
		// save the closest player distance away from the spawn point
		if( dist < spawnpoint.minDist[team] )
		{
			spawnpoint.minDist[team] = dist;
		}
		
		weight = getPlayerWeight( player, currentTime );
		
		spawnpoint.distSum[ team ] += dist;
		spawnpoint.weightedDistSum[ team ] += dist * weight;
		spawnpoint.totalPlayers[team]++;
		
		playerHeight = getPlayerTraceHeight( player );

		prof_begin( " spawn_update_trace" );
		sightValue = SpawnSightTrace( spawnpoint, spawnpoint.origin + (0,0,playerHeight), player.origin + (0,0,playerHeight) );
		prof_end( " spawn_update_trace" );
		
		if( sightValue > 0 )
		{
			spawnpoint.sights[team]++;
		}
	}
	
	// perform additional sight checks on kill streak entities
	additionalSightTraceEntities( spawnpoint, level.turrets );
	additionalSightTraceEntities( spawnpoint, level.ugvs );
	
	if ( IsDefined(spawnpoint.dropToGround) )
	{
		spawnpoint.origin = DropToGround( spawnpoint.origin );
		spawnpoint.dropToGround = undefined;
	}
}


//============================================
// 			initSpawnPointValues
//============================================
initSpawnPointValues( spawnPoint )
{
	if( level.teambased )
	{
		foreach( teamName in level.teamNameList )
		{
			clearSpawnPointValues( spawnPoint, teamName );
		}
	}
	else
	{
		clearSpawnPointValues( spawnPoint, "all" );
	}
}


//============================================
// 			clearSpawnPointValues
//============================================
clearSpawnPointValues( spawnPoint, team )
{
	spawnPoint.sights[team] 			= 0;
	spawnPoint.distSum[team] 			= 0;
	spawnPoint.weightedDistSum[team] 	= 0;	
	spawnPoint.minDist[team] 			= 9999999;
	spawnPoint.totalPlayers[team] 		= 0;
}


//============================================
// 			getPlayerTraceHeight
//============================================
getPlayerTraceHeight( player, bReturnMaxHeight )
{
	if( IsDefined(bReturnMaxHeight) && bReturnMaxHeight )
	{
		return 72;
	}
	
	if( player GetStance() == "stand" )
	{
		return 72;
	}
		
	if( player GetStance() == "crouch" )
	{
		return 54;
	}
		
	return 32;
}


//============================================
// 			getPlayerWeight
//============================================
getPlayerWeight( player, currentTime )
{
	weight = 1.0; 
		
	// reduce the wight of recent tactical insertion spawns
	if( player.wasTI && ( (currentTime - player.spawnTime) < 15000) )
	{
		weight *= 0.1;
	}
	
	// reduce the wight of snipers
	if( player.isSniper )
	{
		weight *= 0.5;
	}
		
	return weight;
}


//============================================
// 		additionalSightTraceEntities
//============================================
additionalSightTraceEntities( spawnPoint, entArray )
{
	team = "all";
	
	foreach( ent in entArray )
	{
		if( !isDefined( ent ) )
			continue;

		prof_begin( " spawn_update_trace" );
		sightValue = SpawnSightTrace( spawnpoint, spawnpoint.sightTracePoint, ent.origin + (0,0,50) );
		prof_end( " spawn_update_trace" );
		
		if( level.teambased )
		{
			team = ent.team;
		}

		if( sightValue > 0 )
		{
			spawnpoint.sights[team]++;
		}
	}
}


//============================================
// 		finalizeSpawnpointChoice
//============================================
finalizeSpawnpointChoice( spawnpoint )
{
	time = getTime();
	
	self.lastspawnpoint 		= spawnpoint;
	self.lastspawntime 			= time;
	
	spawnpoint.lastspawntime 	= time;
	spawnpoint.lastspawnteam 	= self.team;
	
	/#
	spawningDebugHUD( spawnpoint );
	#/
}

	
/#
//============================================
// 			spawningDebugHUD
//============================================
spawningDebugHUD( spawnPoint )
{
	if( !allowDebugHud() )
	{
		destroySpawningDebugHUD();
		return;
	}
	
	createSpawningHUD();
	
	spawningHUDColor = ( 0, 1, 0 );
	
	// buddy spawning
	if( IsDefined(spawnPoint.buddySpawn) && spawnPoint.buddySpawn )
	{
		spawningHUDColor = ( 0.5, 0.5, 1 );
		spawnPoint.numberOfPossibleSpawnChoices = 999;
	}
	
	// display the number of available spawns that the player could possibly choose from
	if( IsDefined( spawnPoint.numberOfPossibleSpawnChoices ) )
	{
		self.spawningAvailableNum setValue( spawnPoint.numberOfPossibleSpawnChoices );
		
		// the hud turns red when there are few than 3 spawn points available 
		if( spawnPoint.numberOfPossibleSpawnChoices < 3 )
		{
			spawningHUDColor = ( 1, 0, 0 );
		}
	}
	
	// display the spawn point's final score value
	if( IsDefined(spawnPoint.totalScore ) )
	{
		self.spawningScoreNum setValue( spawnPoint.totalScore );
	}
		
	setSpawningHUDColor( spawningHUDColor );
}


//============================================
// 				allowDebugHud
//============================================
allowDebugHud()
{
	if( !level.debugSpawning )
		return false;
	
	if( level.inGracePeriod )
		return false;
		
	if( level.players.size == 1 )
		return false;
	
	switch( level.gametype )
	{
		case "war":
		case "conf":
		case "dom":
		case "dm":
			return true;
		default:
			return false;
	}
	
	return  false;
}


//============================================
// 			setSpawningHUDColor
//============================================
setSpawningHUDColor( color )
{ 
	self.spawningAvailableText.color 	= color;
	self.spawningAvailableNum.color 	= color;
	self.spawningScoreText.color 		= color;
	self.spawningScoreNum.color 		= color;
}


//============================================
// 			destroySpawningDebugHUD
//============================================
destroySpawningDebugHUD()
{
	if( isDefined( self.spawningAvailableText ) )
	{
		self.spawningAvailableText Destroy();
	}
	
	if( isDefined( self.spawningAvailableNum ) )
	{
		self.spawningAvailableNum Destroy();
	}
	
	if ( isDefined( self.spawningScoreText ) )
	{
		self.spawningScoreText Destroy();
	}
	
	if ( isDefined( self.spawningScoreNum ) )
	{
		self.spawningScoreNum Destroy();
	}
}


//============================================
// 			createSpawningHUD
//============================================
createSpawningHUD()
{
	if( !isDefined( self.spawningAvailableText ) )
	{
		self.spawningAvailableText = createSpawningHUDElement( 0, 200 );
		self.spawningAvailableText setText( &"MP_DEV_AVAILABLE_SPAWNS" );
	}
	
	if( !isDefined( self.spawningAvailableNum ) )
	{
		self.spawningAvailableNum = createSpawningHUDElement( 95, 200 );
		self.spawningAvailableNum setValue( 0 );
	}
	
	if ( !isDefined( self.spawningScoreText ) )
	{
		self.spawningScoreText = createSpawningHUDElement( 0, 212 );
		self.spawningScoreText setText( &"MP_DEV_AVAILABLE_SPAWNS_SCORE" );
	}
	
	if ( !isDefined( self.spawningScoreNum ) )
	{
		self.spawningScoreNum = createSpawningHUDElement( 95, 212 );
		self.spawningScoreNum setValue( 0 );
	}
}


//============================================
// 		createSpawningHUDElement
//============================================
createSpawningHUDElement( xOffset, yOffset )
{
	spawningHUD = newClientHudElem( self );
	
	spawningHUD.archived 		= false;
	spawningHUD.x 				= -100 + xOffset;		
	spawningHUD.y 				= 10 + yOffset;
	spawningHUD.alignX 			= "left";
	spawningHUD.alignY 			= "top";
	spawningHUD.horzAlign 		= "right";
	spawningHUD.vertAlign 		= "top";
	spawningHUD.sort 			= 10;
	spawningHUD.font 			= "small";
	spawningHUD.foreground 		= true;
	spawningHUD.hideWhenInMenu 	= true;
	spawningHUD.fontscale 		= 1.2;
	spawningHUD.alpha 			= 1;
	
	return spawningHUD;
}
#/
	
/#
spawnInfoWriter()
{
	level waittill( "game_ended" ); 
	
	mapName = getdvar( "ui_mapname" );
	
	spawnDataFile = OpenFile( "spawn_info.txt", "append" );
	
	FPrintLn( spawnDataFile, "SPAWN DATA FOR: " + mapName );
	FPrintLn( spawnDataFile, " " );
	
	foreach( spawn in level.spawnLogData )
	{
		ResetTimeout();
		FPrintLn( spawnDataFile, "Spawn Point Origin: " + spawn.origin );
		FPrintLn( spawnDataFile, "Number of players spawned from this point: " + spawn.spawncount );
		FPrintLn( spawnDataFile, " " );
		
		ReconSpatialEvent( spawn.origin, "script_mp_spawner: count %d", spawn.spawncount );
	}
	println( "File Written" );
	
	wait( 1 );
	CloseFile(spawnDataFile);
}
#/

