#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
================
init
================
*/
init()
{
	precacheShader( "objpoint_default" );
	
	level.gridSize = (128,128.0,128.0);
	level.maxNodeHistory = 8;
	
	if ( !isDefined( game["gridNodes"] ) )
		game["gridNodes"] = [];
	if ( !isDefined( game["gridNodeList"] ) )
		game["gridNodeList"] = [];
		
	if ( !isDefined( game["gridLinks"] ) )
		game["gridLinks"] = [];
	if ( !isDefined( game["gridLinkList"] ) )
		game["gridLinkList"] = [];
		
	if ( !isDefined( game["gridTraverses"] ) )
		game["gridTraverses"] = 0;
	if ( !isDefined( game["gridTotalTraverses"] ) )
		game["gridTotalTraverses"] = 0;
	if ( !isDefined( game["gridMaxTraverses"] ) )
		game["gridMaxTraverses"] = 0;
	level.gridAverageTraverse = 0;
		
	if ( !isDefined( game["gridRunningTraverses"] ) )
		game["gridRunningTraverses"] = 0;
	if ( !isDefined( game["gridTotalRunningTraverses"] ) )
		game["gridTotalRunningTraverses"] = 0;
	if ( !isDefined( game["gridMaxRunningTraverses"] ) )
		game["gridMaxRunningTraverses"] = 0;
	level.gridAverageRunningTraverse = 0;

	if ( !isDefined( game["gridTotalUseTime"] ) )
		game["gridTotalUseTime"] = 0;
	if ( !isDefined( game["gridMaxUseTime"] ) )
		game["gridMaxUseTime"] = 0;
	level.gridTotalUseTime = 0;
		
	if ( !isDefined( game["killLog"] ) )
		game["killLog"] = [];

		
	initClassInfo();
	initWeaponStats();
	initDvars();

	if ( !getDvarInt( "scr_gamestats_enabled" ) )
		return;

	level thread onPlayerConnect();
	level thread updateGameStatDisplay();
}


initDvars()
{
	if ( getDvar( "scr_gamestats_enabled" ) == "" )
		setDvar( "scr_gamestats_enabled", "0" );

	if ( getDvar( "scr_gamestats_timelimit" ) == "" )
		setDvar( "scr_gamestats_timelimit", "0" );
		
	if ( getDvar( "scr_gamestats_showkills" ) == "" )
		setDvar( "scr_gamestats_showkills", "0" );
		
	if ( getDvar( "scr_gamestats_showkills_filter" ) == "" )
		setDvar( "scr_gamestats_showkills_filter", "" );
		
	if ( getDvar( "scr_gamestats_showpaths" ) == "" )
		setDvar( "scr_gamestats_showpaths", "0" );

	if ( getDvar( "scr_gamestats_showusage" ) == "" )
		setDvar( "scr_gamestats_showusage", "0" );
}


initClassInfo()
{
	if ( !isDefined( game["classStats"] ) )
		game["classStats"] = [];

	for ( index = 0; index < level.classList.size; index++ )
	{
		if ( isDefined( game["classStats"][level.classList[index]] ) )
			continue;
			
		classStat = spawnStruct();
		classStat.classTime = 0;
		classStat.avgLifeTime = 0;
		classStat.numLives = 0;
		classStat.numKills = 0;

		game["classStats"][level.classList[index]] = classStat;
	}	
}


initWeaponStats()
{	
	if ( !isDefined( game["weaponStats"] ) )
		game["weaponStats"] = [];

	for ( index = 0; index < level.weaponList.size; index++ )
	{
		if ( isDefined( game["weaponStats"][level.weaponList[index]] ) )
			continue;
			
		weaponStat = spawnStruct();
		weaponStat.numKills = 0;
		weaponStat.killDist = 0;
		weaponStat.killLinks = [];
		weaponStat.killLinkList = [];

		game["weaponStats"][level.weaponList[index]] = weaponStat;
	}
}



updateGameStatDisplay()
{
	timeSlice = 0.05;
	for ( ;; )
	{
		if ( getDvarInt( "scr_gamestats_showkills" ) )
			thread drawPlayerKills( timeSlice );
			
		if ( getDvarInt( "scr_gamestats_showpaths" ) )
			thread drawPlayerPaths( timeSlice, true, true );

		if ( getDvarInt( "scr_gamestats_showusage" ) )
			thread drawPlayerUsage( timeSlice );

		wait ( timeSlice );
	}
}


updateLinkGlobals()
{
	if ( game["gridTotalTraverses"] )
		level.gridAverageTraverse = (game["gridTotalTraverses"] / game["gridTraverses"]);
		
	if ( game["gridTotalRunningTraverses"] )
		level.gridAverageRunningTraverse = (game["gridTotalRunningTraverses"] / game["gridRunningTraverses"]);	
}


updateGridUseGlobals( updateVal )
{
	if ( game["gridTotalUseTime"] )
		level.gridAvgUseTime = (game["gridTotalUseTime"] / game["gridNodes"].size);
}


updateWeaponGlobals( updateVal )
{
}


updateClassGlobals( updateVal )
{
}


trackDelayWeapons()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if ( !self hasWeapon( "frag_grenade_mp" ) )
		return;
	
	lastFragCount = self getAmmoCount( "frag_grenade_mp" );
	for ( ;; )
	{
		count = self getAmmoCount( "frag_grenade_mp" );
		
		if ( count < lastFragCount )
		{
			self.throwNode = getGridNode( self.origin );
			self.throwClass = maps\mp\gametypes\_class::getClass();
		}
		lastFragCount = count;
		wait ( 0.05 );
	}
}


dumpKillLog()
{
	for ( index = 0; index < game["killLog"].size; index++ )
		println( "GameStat: " + game["killLog"][index] );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	for(;;)
	{
		self waittill("spawned_player");
		self thread trackPlayerStats();
		self thread onPlayerDeath();
		self thread onPlayerDisconnect();
		self thread onEndTracking();
		self thread trackDelayWeapons();
	}
}


trackPlayerStats()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	timeSlice = 0.1;

	self.spawnTime = getTime();
	for ( index = 0; index < level.maxNodeHistory; index++ )
		self.nodeHistory[index] = "";
	
	gridNode = getGridNode( self.origin );
	self.nodeHistory[0] = gridNode getNodeHash();
	
	for ( ;; )
	{
		self updatePosition( timeSlice );
		wait ( timeSlice );
	}
}


processGameStats()
{
/#
	/*
	if ( getDvarFloat( "scr_gamestats_timelimit" ) )
	{
		waittillframeend;
		players = getentarray( "player", "classname" );
	
		for ( i = 0; i < players.size; i++ )
		{
			players[i] closeMenu();
			players[i] closeInGameMenu();
			players[i] [[level.spawnSpectator]]();
			players[i] allowSpectateTeam("allies", true);
			players[i] allowSpectateTeam("axis", true);
			players[i] allowSpectateTeam("freelook", true);
			players[i] allowSpectateTeam("none", true);
		}
		
		
		wait ( getDvarFloat( "scr_gamestats_timelimit" ) );
	}
	*/
	

	if ( !getDvarInt( "scr_gamestats_enabled" ) )
		return;

	fileName = (level.script + "_" + level.gametype + ".stats");
	fileNum = openFile( fileName, "read" );
	
	if ( fileNum != -1 )
	{
		loadGameStats( fileNum );
		closeFile( fileNum );
	}
	
	fileNum = openFile( fileName, "write" );
	
	if ( fileNum != -1 )
	{
		saveGameStats( fileNum );
		closeFile( fileNum );
	}
#/
}


saveGameStats( fileNum )
{
	writeGridNodes( fileNum );
	writeGridLinks( fileNum );
	writeWeaponStats( fileNum );
	writeClassStats( fileNum );
}


loadGameStats( fileNum )
{
/#
	numLines = fReadLn( fileNum );
	while ( numLines )
	{
		for ( index = 0; index < numLines; index++ )
		{
			lineString = fGetArg( fileNum, index );
			tokens = strTok( lineString, ":" );
			assert( tokens.size == 2 );
			
			switch( tokens[0] )
			{
				case "node":
					parseNode( tokens[1] );
				break;
				
				case "link":
					parseLink( tokens[1] );
				break;
				
				case "weaponStat":
					parseWeaponStat( tokens[1] );
				break;
				
				case "classStat":
					parseClassStat( tokens[1] );
				break;
			}
		}
		numLines = fReadLn( fileNum );
	}
#/
}


writeGridNodes( fileNum )
{
	for ( nodeIndex = 0; nodeIndex < game["gridNodes"].size; nodeIndex++ )
	{
		nodeHash = game["gridNodeList"][nodeIndex];
		gridNode = game["gridNodes"][nodeHash];

		nodeString = "node:";
		
		nodeString += vectorToString( gridNode getNodeOrigin() );
		nodeString += ";";
		nodeString += nodeHash;
		nodeString += ";";
		nodeString += gridNode getNodeUseTime();
		nodeString += ";";
		nodeString += vectorToString( gridNode getNodeAvgUsePos() );
		
		fPrintFields( fileNum, nodeString );
	}
}

parseNode( string )
{
	tokens = strTok( string, ";" );
	assert( tokens.size == 4 );
	origin = stringToVector( tokens[0] );
	nodeHash = tokens[1];
	useTime = stringToFloat( tokens[2] );
	avgUsePos = stringToVector( tokens[3] );

	addGridNode( origin, nodeHash, useTime, avgUsePos );
}


writeGridLinks( fileNum )
{
	assert( game["gridLinkList"].size == game["gridLinks"].size );
	
	for ( linkIndex = 0; linkIndex < game["gridLinks"].size; linkIndex++ )
	{
		linkHash = game["gridLinkList"][linkIndex];
		gridLink = game["gridLinks"][linkHash];
		
		linkString = "link:";
		linkString += linkHash;
		linkString += ";";
		linkString += gridLink.numTraverses;
		linkString += ";";
		linkString += gridLink.runningTraverses;

		fPrintFields( fileNum, linkString );
	}
}

parseLink( string )
{
	tokens = strTok( string, ";" );
	assert( tokens.size == 3 );
	linkHash = tokens[0];
	numTraverses = int(tokens[1]);
	runningTraveses = int(tokens[2]);
	
	addGridLink( linkHash, numTraverses, runningTraveses );
}


writeWeaponStats( fileNum )
{
	for ( index = 0; index < level.weaponList.size; index++ )
	{
		weaponStat = getWeaponStat( level.weaponList[index] );
		if ( !weaponStat.killLinkList.size )
			continue;
		
		weaponStatString = "weaponStat:";
		weaponStatString += level.weaponList[index];
		
		for ( linkIndex = 0; linkIndex < weaponStat.killLinkList.size; linkIndex++ )
		{
			linkHash = weaponStat.killLinkList[linkIndex];
			weaponStatString += ";";
			weaponStatString += linkHash;
			weaponStatString += "|";
			weaponStatString += weaponStat.killLinks[linkHash];
		}
		fPrintFields( fileNum, weaponStatString );
	}
}

parseWeaponStat( string )
{
	tokens = strTok( string, ";" );
	
	weaponStat = getWeaponStat( tokens[0] );
	
	for ( index = 1; index < tokens.size; index++ )
	{
		killLinkStrings = strTok( tokens[index], "|" );
		assert( killLinkStrings.size == 2 );
		linkHash = killLinkStrings[0];
		weaponStat addKillLinkByHash( linkHash, int(killLinkStrings[1]) );
	}
}


writeClassStats( fileNum )
{
	for ( index = 0; index < level.classList.size; index++ )
	{
		classStat = getClassStat( level.classList[index] );
		if ( !classStat.numLives )
			continue;
			
		classStatString = "classStat:";
		classStatString += level.classList[index];
		classStatString += ";";
		classStatString += classStat.classTime;
		classStatString += ";";
		classStatString += classStat.numLives;
		classStatString += ";";
		classStatString += classStat.numKills;

		fPrintFields( fileNum, classStatString );
	}
}

parseClassStat( string )
{
	tokens = strTok( string, ";" );
	
	classStat = getClassStat( tokens[0] );
	classTime = int(tokens[1]);
	numLives = int(tokens[2]);
	numKills = int(tokens[2]);
	
	classStat addClassStatTime( classTime, numLives );
	classStat addClassStatKill( "none", numKills );
}

onPlayerDeath()
{
	self endon ( "disconnect" );
	
	self waittill ( "death" );
	
	classStat = getClassStat( self.curClass );
	classStat addClassStatTime( getTime() - self.spawnTime, 1 );
}


onPlayerDisconnect()
{
	self endon ( "death" );
	
	self waittill ( "disconnect" );
	
	classStat = getClassStat( self.curClass );
	classStat addClassStatTime( getTime() - self.spawnTime, 1 );
}
/*
	while ( true )
	{
		self waittill ( "set_class" );
		class = self maps\mp\gametypes\_class::getClass();
	}
*/
onEndTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	level waittill( "game_ended" );

	classStat = getClassStat( self.curClass );
	classStat addClassStatTime( getTime() - self.spawnTime, 1 );
}


updatePosition( timeSlice )
{
	gridNode = getGridNode( self.origin );

	gridNode addNodeUseTime( timeSlice );
	gridNode updateAvgUsePos( self.origin, timeSlice );

	self addToNodeHistory( gridNode );

//	thread drawGridBounds( gridNode, timeSlice );
}


addToNodeHistory( gridNode )
{
	nodeHash = gridNode getNodeHash();

	if ( self.nodeHistory[0] == nodeHash )
		return;

	gridLink = getGridLink( getGridNode( hashToOrigin( self.nodeHistory[0] ) ), gridNode );
	gridLink addLinkTraverse( 1 );

	if ( isDefined( self.enterTime ) )
		println( "inTime: " + (getTime() - self.enterTime) );
	
	self.enterTime = getTime();

	if ( !self isInNodeHistory( nodeHash ) )
		self thread addLinkTraverseDelayed( gridLink, 1, 0.8 );
	
	for ( index = level.maxNodeHistory - 1; index > 0; index-- )
		self.nodeHistory[index] = self.nodeHistory[index - 1];

	self.nodeHistory[0] = nodeHash;
}


addLinkTraverseDelayed( gridTraverse, count, timeOut )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "timeout" );
	
	self notify ( "add_running_traverse" );
	self thread notifyTimeOut( timeOut );

	self waittill ( "add_running_traverse" );

	println( "adding running traverse" );
	gridTraverse addLinkRunningTraverse( count );
} 


notifyTimeOut( timeOut )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "add_running_traverse" );

	wait ( timeOut );
	println( "timing out traverse" );

	self notify ( "timeout" );
}


updateKill( attacker, victim, weapon )
{
	// don't track certain weapons for now
	if ( isInWeaponList( weapon ) )
	{
		if ( (weapon == "c4_mp" || weapon == "claymore_mp" || weapon == "pipebomb_mp" || weapon == "ied_mp") && isDefined( victim.damageOrigin ) )
		{
			attackerNode = getGridNode( victim.damageOrigin );
			attackerClass = attacker maps\mp\gametypes\_class::getClass();
		}
		else if ( weapon == "frag_grenade_mp" && isDefined( attacker.throwNode ) )
		{
			attackerNode = attacker.throwNode;
			attackerClass = attacker.throwClass;
		}
		else
		{
			attackerNode = getGridNode( attacker.origin );
			attackerClass = attacker maps\mp\gametypes\_class::getClass();
		}

		victimNode = getGridNode( victim.origin );
		victimClass = victim maps\mp\gametypes\_class::getClass();
		victimWeapon = victim getCurrentWeapon();
		
		weaponStat = getWeaponStat( weapon );
		weaponStat addKillLink( attackerNode, victimNode, 1 );
		classStat = getClassStat( attackerClass );
		classStat addClassStatKill( victimClass, 1 );

		killString = attackerClass + "," + weapon + "," + victimClass + "," + victimWeapon;
		game["killLog"][game["killLog"].size] = killString;
	}	
}


/*
================
gamestats writing
================
*/

addLinkRunningTraverse( count )
{
	if ( !self.runningTraverses )
		game["gridRunningTraverses"] += 1;

	self.runningTraverses += count;
	game["gridTotalRunningTraverses"] += count;

	if ( self.runningTraverses > game["gridMaxRunningTraverses"] )
		game["gridMaxRunningTraverses"] = self.runningTraverses;
	
	updateLinkGlobals();
}


addLinkTraverse( count )
{
	if ( !self.runningTraverses )
		game["gridTraverses"] += 1;

	self.numTraverses += count;
	game["gridTotalTraverses"] += count;

	if ( self.numTraverses > game["gridMaxTraverses"] )
		game["gridMaxTraverses"] = self.numTraverses;

	updateLinkGlobals();
}


addGridNode( origin, nodeHash, useTime, avgUsePos )
{
	gridNode = getGridNode( origin );
	
	gridNode addNodeUseTime( useTime );
	gridNode updateAvgUsePos( avgUsePos, useTime );

	assert( game["gridNodes"].size == game["gridNodeList"].size );
}


addNodeUseTime( timeSlice )
{
	game["gridTotalUseTime"] += timeSlice;
	self.useTime += timeSlice;

	if ( self.useTime > game["gridMaxUseTime"] )
		game["gridMaxUseTime"] = self.useTime;

	updateGridUseGlobals();

	return self.useTime;
}


addGridLink( linkHash, numTraverses, runningTraverses )
{
	gridLink = getGridLinkByHash( linkHash );
	
	gridLink addLinkTraverse( numTraverses );
	gridLink addLinkRunningTraverse( runningTraverses );

	assert( game["gridLinks"].size == game["gridLinkList"].size );
}


addKillLink( nodeSrc, nodeDest, count )
{
	killLinkHash = nodeSrc getNodeHash() + "@" + nodeDest getNodeHash();
	
	if ( !isDefined( self.killLinks[killLinkHash] ) )
	{
		self.killLinks[killLinkHash] = 0;
		self.killLinkList[self.killLinkList.size] = killLinkHash;		
	}
	
	self.killLinks[killLinkHash] += count;
	self.numKills += count;
	
	updateWeaponGlobals( count );
}


addKillLinkByHash( killLinkHash, count )
{
	if ( !isDefined( self.killLinks[killLinkHash] ) )
	{
		self.killLinks[killLinkHash] = 0;
		self.killLinkList[self.killLinkList.size] = killLinkHash;		
	}
	
	self.killLinks[killLinkHash] += count;
	self.numKills += count;
	
	updateWeaponGlobals( count );
}


addClassStatTime( timeSlice, count )
{
	self.classTime += timeSlice;
	self.numLives += count;
	
	self.avgLifeTime = self.classTime / self.numLives;
}


addClassStatKill( victimClass, count )
{
	self.numKills += count;
}


updateAvgUsePos( newUsePos, newUseTime )
{
	x = self.avgUsePos[0] * ((self.useTime - newUseTime) / self.useTime) + newUsePos[0] * (newUseTime / self.useTime);
	y = self.avgUsePos[1] * ((self.useTime - newUseTime) / self.useTime) + newUsePos[1] * (newUseTime / self.useTime);
	z = self.avgUsePos[2] * ((self.useTime - newUseTime) / self.useTime) + newUsePos[2] * (newUseTime / self.useTime);

	self.avgUsePos = (x,y,z);
}


/*
================
gamestats reading
================
*/

getGridNode( origin )
{
	if ( origin[0] > 0 )
		x = int((int(origin[0]) + (level.gridSize[0] / 2)) / level.gridSize[0]);
	else
		x = int((int(origin[0]) - (level.gridSize[0] / 2)) / level.gridSize[0]);

	if ( origin[1] > 0 )
		y = int((int(origin[1]) + (level.gridSize[1] / 2)) / level.gridSize[1]);
	else
		y = int((int(origin[1]) - (level.gridSize[1] / 2)) / level.gridSize[1]);

	if ( origin[2] > 0 )
		z = int((int(origin[2]) + (level.gridSize[2] / 2)) / level.gridSize[2]);
	else
		z = int((int(origin[2]) - (level.gridSize[2] / 2)) / level.gridSize[2]);

	nodeHash = (x+" "+y+" "+z);
	
	if ( !isDefined( game["gridNodes"][nodeHash] ) )
		return createGridNode( (x,y,z), nodeHash );
	else
		return game["gridNodes"][nodeHash];
}


getNodeHash()
{
	return self.hash;
}


getNodeUseTime()
{
	return self.useTime;
}


getNodeAvgUsePos()
{
	return self.avgUsePos;
}


getNodeOrigin()
{
	return self.origin;
}


getGridLink( nodeSrc, nodeDest )
{
	linkHash = nodeSrc getNodeHash() + "@" + nodeDest getNodeHash();
	
	return getGridLinkByHash( linkHash );
}


getGridLinkByHash( linkHash )
{
	if ( !isDefined( game["gridLinks"][linkHash] ) )
		return createGridLink( linkHash );
	else
		return game["gridLinks"][linkHash];
}


getLinkTraverses()
{
	return self.numTraverses;
}


getLinkRunningTraverses()
{
	return self.runningTraverses;
}


getWeaponStat( weapon )
{
	return game["weaponStats"][weapon];
}


getClassStat( class )
{
	return game["classStats"][class];
}

/*
================
drawing
================
*/

drawGridNode()
{
	for ( ;; )
	{
		print3d( self.origin, self.hash, (1,1,1), 1, 1 );
		wait( 0.05 );
	}
}


drawGridBounds( gridNode, timeSlice )
{
	mins = gridNode.origin - (level.gridSize[0]/2, level.gridSize[1]/2, level.gridSize[2]/2); 
	maxs = gridNode.origin + (level.gridSize[0]/2, level.gridSize[1]/2, level.gridSize[2]/2); 
	
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( mins, (mins[0],mins[1],maxs[2]), (1,0,0), false );
		line( mins, (mins[0],maxs[1],mins[2]), (1,0,0), false );
		line( mins, (maxs[0],mins[1],mins[2]), (1,0,0), false );

		line( (mins[0],maxs[1],maxs[2]), (mins[0],maxs[1],mins[2]), (1,0,0), false );
		line( (mins[0],mins[1],maxs[2]), (mins[0],maxs[1],maxs[2]), (1,0,0), false );
		line( (mins[0],mins[1],maxs[2]), (maxs[0],mins[1],maxs[2]), (1,0,0), false );
		
		line( maxs, (maxs[0],maxs[1],mins[2]), (1,0,0), false );
		line( maxs, (maxs[0],mins[1],maxs[2]), (1,0,0), false );
		line( maxs, (mins[0],maxs[1],maxs[2]), (1,0,0), false );

		line( (maxs[0],mins[1],mins[2]), (maxs[0],mins[1],maxs[2]), (1,0,0), false );
		line( (maxs[0],maxs[1],mins[2]), (maxs[0],mins[1],mins[2]), (1,0,0), false );
		line( (maxs[0],maxs[1],mins[2]), (mins[0],maxs[1],mins[2]), (1,0,0), false );
		wait ( 0.05 );
	}
}


drawPlayerUsage( timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		for ( nodeIndex = 0; nodeIndex < game["gridNodeList"].size; nodeIndex++ )
		{
			nodeHash = game["gridNodeList"][nodeIndex];
			if ( game["gridNodes"][nodeHash].useTime < level.gridAvgUseTime )
				continue;
			
			color = game["gridNodes"][nodeHash].useTime / game["gridMaxUseTime"];
			print3d( game["gridNodes"][nodeHash].avgUsePos, ".", (0,0,0), color, 10 );
		}

		wait ( 0.05 );
	}
}


drawPlayerPaths( timeSlice, showTraverses, showRunning )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		for ( index = 0; index < game["gridLinkList"].size; index++ )
		{
			nodeHashes = strTok( game["gridLinkList"][index], "@" );
	
			if ( showTraverses && game["gridLinks"][game["gridLinkList"][index]].numTraverses > level.gridAverageTraverse )
			{
				color = game["gridLinks"][game["gridLinkList"][index]].numTraverses / game["gridMaxTraverses"];
				line( game["gridNodes"][nodeHashes[0]].avgUsePos, game["gridNodes"][nodeHashes[1]].avgUsePos, (1,color,0), false );				
			}

			if ( showRunning && game["gridLinks"][game["gridLinkList"][index]].runningTraverses > level.gridAverageRunningTraverse )
			{
				color = game["gridLinks"][game["gridLinkList"][index]].runningTraverses / game["gridMaxRunningTraverses"];
				line( game["gridNodes"][nodeHashes[0]].avgUsePos, game["gridNodes"][nodeHashes[1]].avgUsePos, (color,1,0), false );				
			}
		}
		wait ( 0.05 );
	}
}


drawPlayerKills( timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		for ( index = 0; index < level.weaponList.size; index++ )
		{
			weapon = level.weaponList[index];
			weaponFilter = getDvar( "scr_gamestats_showkills_filter" );
			
			if ( weaponFilter != "" && weaponFilter != weapon )
				continue;

			weaponStat = game["weaponStats"][weapon];
			
			for ( linkIndex = 0; linkIndex < weaponStat.killLinkList.size; linkIndex++ )
			{
				linkHashes = strTok( weaponStat.killLinkList[linkIndex], "@" );
				
				nodeSrc = game["gridNodes"][linkHashes[0]];
				nodeDest = game["gridNodes"][linkHashes[1]];
				
				if ( nodeSrc == nodeDest )
					arrow_vectorScale( 0.95, nodeSrc.avgUsePos + (0,0,80), nodeDest.avgUsePos + (0,0,48), (1,0,0) );
				else
					arrow_vectorScale( 0.95, nodeSrc.avgUsePos + (0,0,48), nodeDest.avgUsePos + (0,0,48), (1,0,0) );
			}
		}
		wait ( 0.05 );
	}
}


/*
================
utilities
================
*/

createGridNode( origin, nodeHash )
{
	origin = vector_multiply( origin, level.gridSize );

	gridNode = spawnStruct();
	gridNode.hash = nodeHash;
	gridNode.origin = origin;
	gridNode.useTime = 0;
	gridNode.avgUsePos = origin;

	game["gridNodes"][nodeHash] = gridNode;
	game["gridNodeList"][game["gridNodeList"].size] = nodeHash;

	return game["gridNodes"][nodeHash];
}

createGridLink( linkHash )
{
	gridLink = spawnStruct();
	gridLink.hash = linkHash;
	gridLink.numTraverses = 0;
	gridLink.runningTraverses = 0;

	game["gridLinks"][linkHash] = gridLink;
	game["gridLinkList"][game["gridLinkList"].size] = linkHash;
	
	assert( game["gridLinkList"].size == game["gridLinks"].size );

	return game["gridLinks"][linkHash];
}

hashToOrigin( nodeHash )
{
	originPoints = strtok( nodeHash, " " );
	assert( originPoints.size == 3 );
	
	x = int(originPoints[0]) * level.gridSize[0];
	y = int(originPoints[1]) * level.gridSize[1];
	z = int(originPoints[2]) * level.gridSize[2];
	
	return (x,y,z);
}

vectorToString( vector )
{
	return ("( " + vector[0] + " " + vector[1] + " " + vector[2]+ " )");
}

stringToVector( string )
{
	tokens = strTok( string, " " );
	assert( tokens.size == 5 );

	return (stringToFloat( tokens[1] ),stringToFloat( tokens[2] ),stringToFloat( tokens[3] ));
}

stringToFloat( string )
{
	floatParts = strTok( string, "." );
	if ( floatParts.size == 1 )
		return int(floatParts[0]);
		
	whole = int(floatParts[0]);
	decimal = int(floatParts[1]);
	while ( decimal > 1 )
		decimal *= 0.1;
		
	if ( whole > 0 )
		return (whole + decimal);
	else
		return (whole - decimal);
}

printVector( vector )
{
	print( "("+vector[0]+","+vector[1]+","+vector[2]+")" );
}

line_vectorScale( scale, src, dest, color )
{
	vector = vectorNormalize( src - dest );
	dist = distance( src, dest );
	dest = vector_scale( vector, dist * scale ) + src;
	line( src, vector_scale( vector, dist * scale ) + src, color, false );
}

line_vectorLength( length, src, dest, color )
{
	vector = vectorNormalize( src - dest );
	dest = vector_scale( vector, length ) + src;
	line( src, dest, color, false );
}

arrow_vectorScale( scale, src, dest, color )
{
	vector = vectorNormalize( dest - src );
	dist = distance( src, dest );
	dest = vector_scale( vector, dist * scale ) + src;
	line( src, dest, color, false );

	side = vectorNormalize( getVectorRightAngle( dest - src ) );	
	line( dest, dest - vector_scale( vector, 24 ) + vector_scale(side, 16), color, 1, false );
	line( dest, dest - vector_scale( vector, 24 ) - vector_scale(side, 16), color, 1, false );
}

arrow_vectorLength( length, src, dest, color )
{
	vector = vectorNormalize( dest - src );
	dest = vector_scale( vector, length ) + src;
	line( src, dest, color, false );

	side = vectorNormalize( getVectorRightAngle( dest - src ) );	
	line( dest, dest - vector_scale( vector, 24 ) + vector_scale(side, 16), color, 1, false );
	line( dest, dest - vector_scale( vector, 24 ) - vector_scale(side, 16), color, 1, false );
}

getVectorRightAngle( vector )
{
	return (vector[1], 0 - vector[0], vector[2]);
}

isInWeaponList( weapon )
{
	for ( index = 0; index < level.weaponList.size; index++ )
	{
		if ( level.weaponList[index] == weapon )
			return true;
	}
	
	return false;
}

isInNodeHistory( nodeHash )
{
	for ( index = 0; index < level.maxNodeHistory; index++ )
	{
		if ( self.nodeHistory[index] == nodeHash )
			return true;
	}
	return false;
}
