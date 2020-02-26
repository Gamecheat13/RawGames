#include common_scripts\utility;

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		level.players[level.players.size] = player;
		player thread removePlayerOnDisconnect();
	}
}

removePlayerOnDisconnect()
{
	self waittill( "disconnect" );

	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
}

findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}

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


addSpawnPoints( team, spawnPointName )
{
	oldSpawnPoints = [];
	if ( level.teamSpawnPoints[team].size )
		oldSpawnPoints = level.teamSpawnPoints[team];
	
	level.teamSpawnPoints[team] = getEntArray( spawnPointName, "classname" );

	if( game["state"] != "prematch" && !level.teamSpawnPoints[team].size )
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		wait 1; // so we don't try to abort more than once before the frame ends
		return;
	}

	for( index = 0; index < level.teamSpawnPoints[team].size; index++ )
	{
		origin = level.teamSpawnPoints[team][index].origin;

		level.spawnMins = expandMins( level.spawnMins, origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, origin );

		level.teamSpawnPoints[team][index] placeSpawnpoint();
	}

	for( index = 0; index < oldSpawnPoints.size; index++ )
	{
		origin = oldSpawnPoints[index].origin;
		
		level.spawnMins = expandMins( level.spawnMins, origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, origin );

		level.teamSpawnPoints[team][level.teamSpawnPoints[team].size] = oldSpawnPoints[index];
	}
}

getTeamSpawnPoints( team )
{
	return level.teamSpawnPoints[team];
}

// selects a spawnpoint, preferring ones with heigher weights (or toward the beginning of the array if no weights).
// also does final things like setting self.lastspawnpoint to the one chosen.
// this takes care of avoiding telefragging, so it doesn't have to be considered by any other function.
getSpawnpoint_Final(spawnpoints, useweights)
{
	prof_begin(" spawn_final");
	
	bestspawnpoint = undefined;
	
	if(!isdefined(spawnpoints) || spawnpoints.size == 0)
		return undefined;
	
	if (!isdefined(useweights))
		useweights = true;
	
	if (useweights)
	{
		// choose spawnpoint with best weight
		// (if a tie, choose randomly from the best)
		bestspawnpoints = [];
		bestweight = undefined;
		for (i = 0; i < spawnpoints.size; i++)
		{
			if ( !isdefined(bestweight) || spawnpoints[i].weight > bestweight) 
			{
				if(positionWouldTelefrag(spawnpoints[i].origin))
					continue;
	
				bestspawnpoints = [];
				bestspawnpoints[0] = spawnpoints[i];
				bestweight = spawnpoints[i].weight;
			}
			else if (spawnpoints[i].weight == bestweight) 
			{
				if(positionWouldTelefrag(spawnpoints[i].origin))
					continue;
	
				bestspawnpoints[bestspawnpoints.size] = spawnpoints[i];
			}
		}
		if (bestspawnpoints.size > 0)
		{
			// pick randomly from the available spawnpoints with the best weight
			bestspawnpoint = bestspawnpoints[randomint(bestspawnpoints.size)];
		}
		// DEBUG
		/*if (isdefined(bestweight)) {
			println("Best weight: " + bestweight);
		}*/
		// DEBUG
		level notify ("stop_spawn_weight_debug");
		thread spawnWeightDebug(spawnpoints);
	}
	else
	{
		// (only place we actually get here from is getSpawnpoint_Random() )
		// no weights. prefer spawnpoints toward beginning of array
		for (i = 0; i < spawnpoints.size; i++)
		{
			if(isdefined(self.lastspawnpoint) && self.lastspawnpoint == spawnpoints[i])
				continue;
			
			if(positionWouldTelefrag(spawnpoints[i].origin))
				continue;
	
			bestspawnpoint = spawnpoints[i];
			break;
		}
		if (!isdefined(bestspawnpoint))
		{
			// Couldn't find a useable spawnpoint. All spawnpoints either telefragged or were our last spawnpoint
			// Our only hope is our last spawnpoint - unless it too will telefrag...
			if (isdefined(self.lastspawnpoint) && !positionWouldTelefrag(self.lastspawnpoint.origin)) {
				// (make sure our last spawnpoint is in the valid array of spawnpoints to use)
				for (i = 0; i < spawnpoints.size; i++) {
					if (spawnpoints[i] == self.lastspawnpoint) {
						bestspawnpoint = spawnpoints[i];
						break;
					}
				}
			}
		}
	}

	if (!isdefined(bestspawnpoint))
	{
		// couldn't find a useable spawnpoint! all will telefrag.
		if (useweights) {
			// at this point, forget about weights. just take a random one.
			bestspawnpoint = spawnpoints[randomint(spawnpoints.size)];
		}
		else
			bestspawnpoint = spawnpoints[0];
	}
	
	time = getTime();
	
	self.lastspawnpoint = bestspawnpoint;
	self.lastspawntime = time;
	bestspawnpoint.lastspawnedplayer = self;
	bestspawnpoint.lastspawntime = time;

	/#
	self storeSpawnData(spawnpoints, useweights, bestspawnpoint);
	#/
	
	prof_end(" spawn_final");

	return bestspawnpoint;
}

/#
storeSpawnData(spawnpoints, useweights, bestspawnpoint)
{
	if (!isdefined(level.storeSpawnData) || !level.storeSpawnData)
		return;

	level.storeSpawnData = getdvarint("scr_recordspawndata");
	if (!level.storeSpawnData)
		return;
	
	if (!isdefined(level.spawnID)) {
		level.spawnGameID = randomint(100);
		level.spawnID = 0;
	}

	if (bestspawnpoint.classname == "mp_global_intermission")
		return;
	
	level.spawnID++;
	
	file = openfile("spawndata.txt", "append");
	fPrintFields(file, level.spawnGameID + "." + level.spawnID + "," + spawnpoints.size + "," + self.name);

	for (i = 0; i < spawnpoints.size; i++)
	{
		str = vectostr(spawnpoints[i].origin) + ",";
		if (spawnpoints[i] == bestspawnpoint)
			str = str + "1,";
		else
			str = str + "0,";
		
		if (!useweights)
			str += "0,";
		else
			str += spawnpoints[i].weight + ",";
		
		if (!isdefined(spawnpoints[i].spawnData))
			spawnpoints[i].spawnData = [];
		if (!isdefined(spawnpoints[i].sightChecks))
			spawnpoints[i].sightChecks = [];
		str += spawnpoints[i].spawnData.size + ",";
		for (j = 0; j < spawnpoints[i].spawnData.size; j++)
		{
			str += spawnpoints[i].spawnData[j] + ",";
		}
		str += spawnpoints[i].sightChecks.size + ",";
		for (j = 0; j < spawnpoints[i].sightChecks.size; j++)
		{
			str += spawnpoints[i].sightChecks[j].penalty + "," + vectostr(spawnpoints[i].origin) + ",";
		}
		
		fPrintFields(file, str);
	}
	
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj);
	str = obj.allies.size + "," + obj.enemies.size + ",";
	for (i = 0; i < obj.allies.size; i++)
	{
		if ( obj.allies[i] == self )
			continue;
		str += vectostr(obj.allies[i].origin) + ",";
	}
	for (i = 0; i < obj.enemies.size; i++)
		str += vectostr(obj.enemies[i].origin) + ",";
	fPrintFields(file, str);
	
	otherdata = [];
	if (isdefined(level.bombguy)) {
		index = otherdata.size;
		otherdata[index] = spawnstruct();
		otherdata[index].origin = level.bombguy.origin + (0,0,20);
		otherdata[index].text = "Bomb holder";
	}
	else if (isdefined(level.bombpos)) {
		index = otherdata.size;
		otherdata[index] = spawnstruct();
		otherdata[index].origin = level.bombpos;
		otherdata[index].text = "Bomb";
	}
	if (isdefined(level.flags)) {
		for (i = 0; i < level.flags.size; i++)
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.flags[i].origin;
			otherdata[index].text = level.flags[i].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() + " flag";
		}
	}
	str = otherdata.size + ",";
	for (i = 0; i < otherdata.size; i++)
	{
		str += vectostr(otherdata[i].origin) + "," + otherdata[i].text + ",";
	}
	fPrintFields(file, str);
	
	closefile(file);

	thisspawnid = level.spawnGameID + "." + level.spawnID;
	if (isdefined(self.thisspawnid)) {
		self iprintln(&"MP_PREVIOUS_SPAWN_ID", self.thisspawnid);
	}
	self iprintln(&"MP_THIS_SPAWN_ID", thisspawnid);
	self.thisspawnid = thisspawnid;
}

readSpawnData()
{
	level.spawndata = [];
	file = openfile("spawndata.txt", "read");
	if (file < 0)
		return;
	while(1)
	{
		if (freadln(file) <= 0)
			break;
		data = spawnstruct();
		
		data.id = fgetarg(file, 0);
		numspawns = int(fgetarg(file, 1));
		if (numspawns > 256)
			break;
		data.playername = fgetarg(file, 2);
		
		data.spawnpoints = [];
		data.friends = [];
		data.enemies = [];
		data.otherdata = [];
		
		for (i = 0; i < numspawns; i++)
		{
			if (freadln(file) <= 0)
				break;
			
			spawnpoint = spawnstruct();
			
			spawnpoint.origin = strtovec(fgetarg(file, 0));
			spawnpoint.winner = int(fgetarg(file, 1));
			spawnpoint.weight = int(fgetarg(file, 2));
			spawnpoint.data = [];
			spawnpoint.sightchecks = [];
			
			if (i == 0) {
				data.minweight = spawnpoint.weight;
				data.maxweight = spawnpoint.weight;
			}
			else {
				if (spawnpoint.weight < data.minweight)
					data.minweight = spawnpoint.weight;
				if (spawnpoint.weight > data.maxweight)
					data.maxweight = spawnpoint.weight;
			}
			
			argnum = 4;

			numdata = int(fgetarg(file, 3));
			if (numdata > 256)
				break;
			for (j = 0; j < numdata; j++)
			{
				spawnpoint.data[spawnpoint.data.size] = fgetarg(file, argnum);
				argnum++;
			}
			numsightchecks = int(fgetarg(file, argnum));
			argnum++;
			if (numsightchecks > 256)
				break;
			for (j = 0; j < numsightchecks; j++)
			{
				index = spawnpoint.sightchecks.size;
				spawnpoint.sightchecks[index] = spawnstruct();
				spawnpoint.sightchecks[index].penalty = int(fgetarg(file, argnum));
				argnum++;
				spawnpoint.sightchecks[index].origin = strtovec(fgetarg(file, argnum));
				argnum++;
			}
			
			data.spawnpoints[data.spawnpoints.size] = spawnpoint;
		}
		
		if (!isdefined(data.minweight)) {
			data.minweight = -1;
			data.maxweight = 0;
		}
		if (data.minweight == data.maxweight)
			data.minweight = data.minweight - 1;
		
		if (freadln(file) <= 0)
			break;
		numfriends = int(fgetarg(file, 0));
		numenemies = int(fgetarg(file, 1));
		if (numfriends > 32 || numenemies > 32)
			break;
		argnum = 2;
		for (i = 0; i < numfriends; i++)
		{
			data.friends[data.friends.size] = strtovec(fgetarg(file, argnum));
			argnum++;
		}
		for (i = 0; i < numenemies; i++)
		{
			data.enemies[data.enemies.size] = strtovec(fgetarg(file, argnum));
			argnum++;
		}

		if (freadln(file) <= 0)
			break;
		numotherdata = int(fgetarg(file, 0));
		argnum = 1;
		for (i = 0; i < numotherdata; i++)
		{
			otherdata = spawnstruct();
			otherdata.origin = strtovec(fgetarg(file, argnum));
			argnum++;
			otherdata.text = fgetarg(file, argnum);
			argnum++;
			
			data.otherdata[data.otherdata.size] = otherdata;
		}
		
		level.spawndata[level.spawndata.size] = data;
	}
	closefile(file);
}
drawSpawnData()
{
	textoffset = (0,0,-12);
	while(1)
	{
		if (!isdefined(level.curspawndata)) {
			wait .5;
			continue;
		}
		
		for (i = 0; i < level.curspawndata.friends.size; i++)
		{
			print3d(level.curspawndata.friends[i], "=)", (.5,1,.5), 1, 5);
		}
		for (i = 0; i < level.curspawndata.enemies.size; i++)
		{
			print3d(level.curspawndata.enemies[i], "=(", (1,.5,.5), 1, 5);
		}
		
		for (i = 0; i < level.curspawndata.otherdata.size; i++)
		{
			print3d(level.curspawndata.otherdata[i].origin, level.curspawndata.otherdata[i].text, (.5,.75,1), 1, 2);
		}

		for (i = 0; i < level.curspawndata.spawnpoints.size; i++)
		{
			sp = level.curspawndata.spawnpoints[i];
			orig = sp.origin + (0,0,50);
			if (sp.winner) {
				print3d(orig, level.curspawndata.playername + " spawned here", (.5,.5,1), 1, 2);
				orig += textoffset;
			}
			amnt = (sp.weight - level.curspawndata.minweight) / (level.curspawndata.maxweight - level.curspawndata.minweight);
			print3d(orig, "Weight: " + sp.weight, (1-amnt,amnt,.5));
			orig += textoffset;
			for (j = 0; j < sp.data.size; j++)
			{
				print3d(orig, sp.data[j], (1,1,1));
				orig += textoffset;
			}
			for (j = 0; j < sp.sightchecks.size; j++)
			{
				//line(sp.origin, sp.sightchecks[j].origin, (1,0,0));
				print3d(orig, "Sightchecks: " + sp.sightchecks[j].penalty, (1,.5,.5));
				orig += textoffset;
			}
		}

		wait .05;
	}
}

vectostr(vec)
{
	return int(vec[0]) + "/" + int(vec[1]) + "/" + int(vec[2]);
}
strtovec(str)
{
	parts = strtok(str, "/");
	if (parts.size != 3)
		return (0,0,0);
	return (int(parts[0]), int(parts[1]), int(parts[2]));
}
#/

getSpawnpoint_Random(spawnpoints)
{
//	level endon("intermission");

	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;

	// randomize order
	for(i = 0; i < spawnpoints.size; i++)
	{
		j = randomInt(spawnpoints.size);
		spawnpoint = spawnpoints[i];
		spawnpoints[i] = spawnpoints[j];
		spawnpoints[j] = spawnpoint;
	}
	
	return getSpawnpoint_Final(spawnpoints, false);
}

getAllOtherPlayers()
{
	aliveplayers = [];

	// Make a list of fully connected, non-spectating, alive players
	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;

		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}


getAllAlliedAndEnemyPlayers(obj)
{
	if ( self.pers["team"] == "allies" )
	{
		obj.allies = level.alliesplayers;
		obj.enemies = level.axisplayers;
	}
	else if ( self.pers["team"] == "axis" )
	{
		obj.allies = level.axisplayers;
		obj.enemies = level.alliesplayers;
	}
	else if ( self.pers["team"] == "free" )
	{
		obj.allies = [];
		obj.enemies = level.freeplayers;
	}
	else
	{
		maps\mp\_utility::error( "trying to spawn player who is not on allies or axis" );
	}
}

// weight array manipulation code
initWeights(spawnpoints)
{
	for (i = 0; i < spawnpoints.size; i++)
		spawnpoints[i].weight = 0;
	
	/#
	if (level.storeSpawnData)
	{
		for (i = 0; i < spawnpoints.size; i++) {
			spawnpoints[i].spawnData = [];
			spawnpoints[i].sightChecks = [];
		}
	}
	#/
}

// ================================================


getSpawnpoint_NearTeam(spawnpoints, favoredspawnpoints, pretendEvenTeams)
{
//	level endon("intermission");

	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;
		
	prof_begin("basic_spawnlogic");
	
	if ( getdvarint("scr_spawnsimple") > 0 )
		return getSpawnpoint_Random( spawnpoints );
	
	Spawnlogic_Begin();
	
	initWeights(spawnpoints);
	
	prof_begin(" getteams");
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj);
	prof_end(" getteams");
	
	numplayers = obj.allies.size + obj.enemies.size;
	
	if (!isdefined(pretendEvenTeams))
		pretendEvenTeams = false;
	
	prof_begin(" sumdists");
	if (numplayers > 0)
	{
		for (i = 0; i < spawnpoints.size; i++)
		{
			allyDistSum = 0;
			enemyDistSum = 0;
			for (j = 0; j < obj.allies.size; j++)
			{
				if ( obj.allies[j] == self )
					continue;
				dist = distance(spawnpoints[i].origin, obj.allies[j].origin);
				allyDistSum += dist;
			}
			for (j = 0; j < obj.enemies.size; j++)
			{
				dist = distance(spawnpoints[i].origin, obj.enemies[j].origin);
				enemyDistSum += dist;
			}
			
			// high enemy distance is good, high ally distance is bad
			
			// if pretendEvenTeams is true, allies or enemies don't get a higher weight just because there are more of them alive.
			// this prevents people popping to the other end of the map when they don't have enough teammates alive as compared to the enemies which are overrunning them.
			if ( pretendEvenTeams )
			{
				if ( obj.enemies.size )
					enemyDistSum /= obj.enemies.size;
				if ( obj.allies.size )
					allyDistSum /= obj.allies.size;
				spawnpoints[i].weight = (enemyDistSum - 2*allyDistSum) / 2;
			}
			else
				spawnpoints[i].weight = (enemyDistSum - 2*allyDistSum) / numplayers;
		}
	}
	prof_end(" sumdists");
	
	if (isdefined(favoredspawnpoints)) {
		for (i = 0; i < favoredspawnpoints.size; i++) {
			favoredspawnpoints[i].weight += 25000;
		}
	}
	
	prof_end("basic_spawnlogic");

	prof_begin("complex_spawnlogic");

	avoidSameSpawn(spawnpoints);
	avoidSpawnReuse(spawnpoints, true);
	// not avoiding spawning near recent deaths for team-based modes. kills the fast pace.
	//avoidDangerousSpawns(spawnpoints, true);
	avoidWeaponDamage(spawnpoints);
	avoidVisibleEnemies(spawnpoints, true);
	
	prof_end("complex_spawnlogic");

	return getSpawnpoint_Final(spawnpoints);
}

/////////////////////////////////////////////////////////////////////////

getSpawnpoint_DM(spawnpoints)
{
//	level endon("intermission");

	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;
	
	Spawnlogic_Begin();

	initWeights(spawnpoints);
	
	aliveplayers = getAllOtherPlayers();
	
	// new logic: we want most players near idealDist units away.
	// players closer than badDist units will be considered negatively
	idealDist = 1600;
	badDist = 1200;
	
	if (aliveplayers.size > 0)
	{
		for (i = 0; i < spawnpoints.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for (j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(spawnpoints[i].origin, aliveplayers[j].origin);
				
				if (dist < badDist)
					nearbyBadAmount += (badDist - dist) / badDist;
				
				distfromideal = abs(dist - idealDist);
				totalDistFromIdeal += distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			
			wellDistancedAmount = (idealDist - avgDistFromIdeal) / idealDist;
			// if (wellDistancedAmount < 0) wellDistancedAmount = 0;
			
			// wellDistancedAmount is between -inf and 1, 1 being best (likely around 0 to 1)
			// nearbyBadAmount is between 0 and inf,
			// and it is very important that we get a bad weight if we have a high nearbyBadAmount.
			
			spawnpoints[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + randomfloat(.2);
		}
	}
	
	avoidSameSpawn(spawnpoints);
	avoidSpawnReuse(spawnpoints, false);
	//avoidDangerousSpawns(spawnpoints, false);
	avoidWeaponDamage(spawnpoints);
	avoidVisibleEnemies(spawnpoints, false);
	
	return getSpawnpoint_Final(spawnpoints);
}

// =============================================

// called at the start of every spawn
Spawnlogic_Begin()
{
	//updateDeathInfo();

	/#
	level.storeSpawnData = getdvarint("scr_recordspawndata");
	#/
}

// called once at start of game
init()
{
	/#
	if (getdvar("scr_recordspawndata") == "")
		setdvar("scr_recordspawndata", 0);
	level.storeSpawnData = getdvarint("scr_recordspawndata");
	
	//thread loopbotspawns();
	#/

	// start keeping track of deaths
	level.spawnlogic_deaths = [];
	// DEBUG
	level.spawnlogic_spawnkills = [];
	level.players = [];
	level.grenades = [];
	level.claymores = [];
	level.pipebombs = [];

	level thread onPlayerConnect();
	level thread trackGrenades();
	level thread trackClaymores();
	
	// DEBUG
	/#
	if (getdvar("scr_spawnsimple") == "")
		setdvar("scr_spawnsimple", "0");
	if (getdvar("scr_spawnpointdebug") == "")
		setdvar("scr_spawnpointdebug", "0");
	if (getdvarint("scr_spawnpointdebug") > 0)
	{
		thread showDeathsDebug();
		thread updateDeathInfoDebug();
		thread profileDebug();
	}
	if (level.storeSpawnData) {
		thread allowSpawnDataReading();
	}
	if (getdvar("scr_spawnprofile") == "")
		setdvar("scr_spawnprofile", "0");
	thread watchSpawnProfile();
	#/
}
/#

watchSpawnProfile()
{
	while(1)
	{
		while(1)
		{
			if (getdvarint("scr_spawnprofile") > 0)
				break;
			wait .05;
		}
		
		thread spawnProfile();
		
		while(1)
		{
			if (getdvarint("scr_spawnprofile") <= 0)
				break;
			wait .05;
		}
		
		level notify("stop_spawn_profile");
	}
}

spawnProfile()
{
	level endon("stop_spawn_profile");
	while(1)
	{
		if ( level.players.size > 0 && level.spawnpoints.size > 0 )
		{
			playerNum = randomint(level.players.size);
			player = level.players[playerNum];
			attempt = 1;
			while ( !isdefined( player ) && attempt < level.players.size )
			{
				playerNum = ( playerNum + 1 ) % level.players.size;
				attempt++;
				player = level.players[playerNum];
			}
			
			player getSpawnpoint_NearTeam(level.spawnpoints);
		}
		wait .05;
	}
}

// DEBUG
loopbotspawns()
{
	while(1)
	{
		bots = [];
		for (i = 0; i < level.players.size; i++)
		{
			if ( !isdefined( level.players[i] ) )
				continue;

			if ( level.players[i].sessionstate == "playing" && issubstr(level.players[i].name, "bot") )
			{
				bots[bots.size] = level.players[i];
			}
		}
		if ( bots.size > 10 )
		{
			bot = bots[randomint(bots.size)];
			bot suicide();
		}
		wait .05;
	}
}
// DEBUG
allowSpawnDataReading()
{
	setdvar("scr_showspawnid", "");
	prevval = getdvar("scr_showspawnid");
	
	readthistime = false;
	
	while(1)
	{
		val = getdvar("scr_showspawnid");
		if (!isdefined(val) || val == prevval) {
			wait(.5);
			continue;
		}
		prevval = val;
		
		readthistime = false;
		
		if (!isdefined(level.spawndata)) {
			readSpawnData();
			thread drawSpawnData();
			readthistime = true;
		}
		
		while (1)
		{
			level.curspawndata = undefined;
			for (i = 0; i < level.spawndata.size; i++)
			{
				if (level.spawndata[i].id == val)
					level.curspawndata = level.spawndata[i];
			}
			if (!isdefined(level.curspawndata)) {
				if (!readthistime) {
					readSpawnData();
					readthistime = true;
				}
				else {
					println("Spawn data for ID " + val + " could not be found.");
					break;
				}
			}
			else
				break;
		}
	}
}
#/
// DEBUG
showDeathsDebug()
{
	while(1)
	{
		if (getdvar("scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}

		time = getTime();
		
		for (i = 0; i < level.spawnlogic_deaths.size; i++)
		{
			if (isdefined(level.spawnlogic_deaths[i].los))
				line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1,0,0)); // line-of-sights are shown in red
			else
				line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1,1,1));
			killer = level.spawnlogic_deaths[i].killer;
			if (isdefined(killer) && isalive(killer))
				line(level.spawnlogic_deaths[i].killOrg, killer.origin, (.4,.4,.8));
		}
		
		for (p = 0; p < level.players.size; p++)
		{
			if ( !isdefined( level.players[p] ) )
				continue;
			if (isdefined(level.players[p].spawnlogic_killdist))
				print3d(level.players[p].origin + (0,0,64), level.players[p].spawnlogic_killdist, (1,1,1));
		}
		
		oldspawnkills = level.spawnlogic_spawnkills;
		level.spawnlogic_spawnkills = [];
		for (i = 0; i < oldspawnkills.size; i++)
		{
			spawnkill = oldspawnkills[i];
			
			/*spawnkill.dierwasspawner = true;
			spawnkill.dierorigin = dier.origin;
			spawnkill.killerorigin = killer.origin;
			spawnkill.spawnpointorigin = dier.lastspawnpoint.origin;
			spawnkill.time = time;*/
			
			if (spawnkill.dierwasspawner) {
				line(spawnkill.spawnpointorigin, spawnkill.dierorigin, (.4,.5,.4));
				line(spawnkill.dierorigin, spawnkill.killerorigin, (0,1,1));
				print3d(spawnkill.dierorigin + (0,0,32), "SPAWNKILLED!", (0,1,1));
			}
			else {
				line(spawnkill.spawnpointorigin, spawnkill.killerorigin, (.4,.5,.4));
				line(spawnkill.killerorigin, spawnkill.dierorigin, (0,1,1));
				print3d(spawnkill.dierorigin + (0,0,32), "SPAWNDIED!", (0,1,1));
			}
			
			if (time - spawnkill.time < 60*1000)
				level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = oldspawnkills[i];
		}
		wait(.05);
	}
}
// DEBUG
updateDeathInfoDebug()
{
	while(1)
	{
		if (getdvar("scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}
		updateDeathInfo();
		wait(3);
	}
}
// DEBUG
spawnWeightDebug(spawnpoints)
{
	level endon("stop_spawn_weight_debug");
	while(1)
	{
		if (getdvar("scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}
		for (i = 0; i < spawnpoints.size; i++)
		{
			amnt = 1 * (1 - spawnpoints[i].weight / (-100000));
			if (amnt < 0) amnt = 0;
			if (amnt > 1) amnt = 1;
			print3d(spawnpoints[i].origin + (0,0,64), spawnpoints[i].weight, (1,amnt,.5));
		}
		wait(.05);
	}
}
// DEBUG
profileDebug()
{
	while(1)
	{
		if (getdvar("scr_spawnpointprofile") != "1") {
			wait(3);
			continue;
		}
		
		for (i = 0; i < level.spawnpoints.size; i++)
			level.spawnpoints[i].weight = randomint(10000);
		if (level.players.size > 0)
			level.players[randomint(level.players.size)] getSpawnpoint_NearTeam(level.spawnpoints);
		
		wait(.05);
	}
}
// DEBUG
debugNearbyPlayers(players, origin)
{
	if (getdvar("scr_spawnpointdebug") == "0") {
		return;
	}
	starttime = gettime();
	while(1)
	{
		for (i = 0; i < players.size; i++)
			line(players[i].origin, origin, (.5,1,.5));
		if (gettime() - starttime > 5000)
			return;
		wait .05;
	}
}

deathOccured(dier, killer)
{
	/*if (!isdefined(killer) || !isdefined(dier) || !isplayer(killer) || !isplayer(dier) || killer == dier)
		return;
	
	time = getTime();
	
	// DEBUG
	// check if there was a spawn kill
	if (time - dier.lastspawntime < 5*1000 && distance(dier.origin, dier.lastspawnpoint.origin) < 300)
	{
		spawnkill = spawnstruct();
		spawnkill.dierwasspawner = true;
		spawnkill.dierorigin = dier.origin;
		spawnkill.killerorigin = killer.origin;
		spawnkill.spawnpointorigin = dier.lastspawnpoint.origin;
		spawnkill.time = time;
		level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = spawnkill;
	}
	else if (time - killer.lastspawntime < 5*1000 && distance(killer.origin, killer.lastspawnpoint.origin) < 300)
	{
		spawnkill = spawnstruct();
		spawnkill.dierwasspawner = false;
		spawnkill.dierorigin = dier.origin;
		spawnkill.killerorigin = killer.origin;
		spawnkill.spawnpointorigin = killer.lastspawnpoint.origin;
		spawnkill.time = time;
		level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = spawnkill;
	}
	
	// record kill information
	deathInfo = spawnstruct();
	
	deathInfo.time = time;
	deathInfo.org = dier.origin;
	deathInfo.killOrg = killer.origin;
	deathInfo.killer = killer;
	
	checkForSimilarDeaths(deathInfo);
	level.spawnlogic_deaths[level.spawnlogic_deaths.size] = deathInfo;
	
	// keep track of the most dangerous players in terms of how far they have killed people recently
	dist = distance(dier.origin, killer.origin);
	if (!isdefined(killer.spawnlogic_killdist) || time - killer.spawnlogic_killtime > 1000*30 || dist > killer.spawnlogic_killdist)
	{
		killer.spawnlogic_killdist = dist;
		killer.spawnlogic_killtime = time;
	}*/
}
checkForSimilarDeaths(deathInfo)
{
	// check if this is really similar to any old deaths, and if so, mark them for removal later
	for (i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		if (level.spawnlogic_deaths[i].killer == deathInfo.killer)
		{
			dist = distance(level.spawnlogic_deaths[i].org, deathInfo.org);
			if (dist > 200) continue;
			dist = distance(level.spawnlogic_deaths[i].killOrg, deathInfo.killOrg);
			if (dist > 200) continue;
			
			level.spawnlogic_deaths[i].remove = true;
		}
	}
}

updateDeathInfo()
{
	prof_begin(" updateDeathInfo");
	
	time = getTime();
	for (i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		// if the killer has walked away or enough time has passed, get rid of this death information
		deathInfo = level.spawnlogic_deaths[i];
		
		if (time - deathInfo.time > 1000*90 || // if 90 seconds have passed
			!isdefined(deathInfo.killer) ||
			!isalive(deathInfo.killer) ||
			(deathInfo.killer.pers["team"] != "axis" && deathInfo.killer.pers["team"] != "allies") ||
			distance(deathInfo.killer.origin, deathInfo.killOrg) > 400) {
			level.spawnlogic_deaths[i].remove = true;
		}
	}
	
	// remove all deaths with remove set
	oldarray = level.spawnlogic_deaths;
	level.spawnlogic_deaths = [];
	
	// never keep more than the 1024 most recent entries in the array
	start = 0;
	if (oldarray.size - 1024 > 0) start = oldarray.size - 1024;
	
	for (i = start; i < oldarray.size; i++)
	{
		if (!isdefined(oldarray[i].remove))
			level.spawnlogic_deaths[level.spawnlogic_deaths.size] = oldarray[i];
	}

	prof_end(" updateDeathInfo");
}

/*
// uses death information to reduce the weights of spawns that might cause spawn kills
avoidDangerousSpawns(spawnpoints, teambased) // (assign weights to the return value of this)
{
	// DEBUG
	if (getdvar("scr_spawnpointnewlogic") == "0") {
		return;
	}

	// DEBUG
	prof_begin("spawn death checks");
	
	deathpenalty = 100000;
	if (getdvar("scr_spawnpointdeathpenalty") != "" && getdvar("scr_spawnpointdeathpenalty") != "0")
		deathpenalty = getdvarfloat("scr_spawnpointdeathpenalty");
	
	maxDist = 200;
	if (getdvar("scr_spawnpointmaxdist") != "" && getdvar("scr_spawnpointmaxdist") != "0")
		maxdist = getdvarfloat("scr_spawnpointmaxdist");
	
	maxDistSquared = maxDist*maxDist;
	for (i = 0; i < spawnpoints.size; i++)
	{
		for (d = 0; d < level.spawnlogic_deaths.size; d++)
		{
			// (we've got a lotta checks to do, want to rule them out quickly)
			distSqrd = distanceSquared(spawnpoints[i].origin, level.spawnlogic_deaths[d].org);
			if (distSqrd > maxDistSquared)
				continue;
			
			// make sure the killer in question is on the opposing team
			player = level.spawnlogic_deaths[d].killer;
			if (!isalive(player)) continue;
			if (player == self) continue;
			if (teambased && player.pers["team"] == self.pers["team"]) continue;
			
			// (no sqrt, must recalculate distance)
			dist = distance(spawnpoints[i].origin, level.spawnlogic_deaths[d].org);
			spawnpoints[i].weight -= (1 - dist/maxDist) * deathpenalty; // possible spawn kills are *really* bad
		}
	}
	
	// DEBUG
	prof_end("spawn death checks");
}
*/

trackClaymores()
{
	while ( 1 )
	{
		level.claymores = getentarray("claymore", "targetname");
		wait .05;
		/*
		level.pipebombs = getentarray("pipebomb", "targetname");
		wait .05;
		*/
	}
}

trackGrenades()
{
	while ( 1 )
	{
		level.grenades = getentarray("grenade", "classname");
		wait .05;
	}
}

avoidWeaponDamage(spawnpoints)
{
	if (getdvar("scr_spawnpointnewlogic") == "0") 
	{
		return;
	}
	
	prof_begin(" spawn_grenade");

	weaponDamagePenalty = 100000;
	if (getdvar("scr_spawnpointweaponpenalty") != "" && getdvar("scr_spawnpointweaponpenalty") != "0")
		weaponDamagePenalty = getdvarfloat("scr_spawnpointweaponpenalty");

	mingrenadedistsquared = 250*250; // (actual grenade radius is 220, 250 includes a safety area of 30 units)

	for (i = 0; i < spawnpoints.size; i++)
	{
		for (j = 0; j < level.grenades.size; j++)
		{
			if ( !isdefined( level.grenades[j] ) )
				continue;

			// could also do a sight check to see if it's really dangerous.
			if (distancesquared(spawnpoints[i].origin, level.grenades[j].origin) < mingrenadedistsquared) {
				spawnpoints[i].weight -= weaponDamagePenalty;
				/#
				if (level.storeSpawnData)
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was near grenade: -" + weaponDamagePenalty;
				#/
			}
		}
		for (j = 0; j < level.claymores.size; j++)
		{
			if ( !isdefined( level.claymores[j] ) )
				continue;

			if (level.claymores[j] maps\mp\_claymores::isPointVulnerable(spawnpoints[i].origin)) {
				spawnpoints[i].weight -= weaponDamagePenalty;
				/#
				if (level.storeSpawnData)
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was near claymore: -" + weaponDamagePenalty;
				#/
			}
		}
		/*for (j = 0; j < level.pipebombs.size; j++)
		{
			if (level.pipebombs[j] maps\mp\_pipebomb::isPointVulnerable(spawnpoints[i].origin))
				spawnpoints[i].weight -= weaponDamagePenalty;
		}*/
		if (isdefined(level.artilleryDangerCenter)) 
		{
			centerdir = spawnpoints[i].origin - level.artilleryDangerCenter;
			centerdir = (centerdir[0], centerdir[1], 0);
			if ( lengthsquared( centerdir ) < level.artilleryDangerMaxRadiusSq ) 
			{
				len = length(centerdir);
				amount = (len - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);
				worsen = 0;
				if (amount < 0)
					worsen = weaponDamagePenalty;
				else
					worsen = (1 - amount) * weaponDamagePenalty;
				spawnpoints[i].weight -= worsen;
				/#
				if (level.storeSpawnData)
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was near artillery: -" + worsen;
				#/
			}
		}
	}

	prof_end(" spawn_grenade");
}

spawnSightChecks()
{
	spawnpointindex = 0;
		
	// each frame, do sight checks against a spawnpoint
	
	prevspawnpoint = undefined;
	
	while(1)
	{
		wait .05;
		
		prof_begin("spawn_sight_checks");

		//time = gettime();

		spawnpointindex = (spawnpointindex + 1) % level.spawnPoints.size;
		spawnpoint = level.spawnPoints[spawnpointindex];
		
		if ( level.teambased )
		{
			spawnpoint.sights["axis"] = 0;
			spawnpoint.sights["allies"] = 0;
		}
		else
			spawnpoint.sights = 0;
		
		spawnpointdir = anglestoforward(spawnpoint.angles);
		
		for (i = 0; i < level.players.size; i++)
		{
			if ( !isdefined( level.players[i] ) )
				continue;
			player = level.players[i];
			
			if ( player.sessionstate != "playing" )
				continue;

			diff = player.origin - spawnpoint.origin;
			pdir = anglestoforward(player.angles);
			if (vectordot(spawnpointdir, diff) < 0 && vectordot(pdir, diff) > 0)
				continue; // player and spawnpoint are looking in opposite directions
			
			// do sight check
			losExists = bullettracepassed(player.origin + (0,0,50), spawnpoint.origin + (0,0,50), false, undefined);
			
			if (losExists)
			{
				if ( level.teamBased )
					spawnpoint.sights[player.pers["team"]]++;
				else
					spawnpoint.sights++;
				
				// DEBUG
				//println("Sight check succeeded!");
				
				/*
				death info stuff is disabled right now
				// pretend this player killed a person at this spawnpoint, so we don't try to use it again any time soon.
				deathInfo = spawnstruct();
				
				deathInfo.time = time;
				deathInfo.org = spawnpoint.origin;
				deathInfo.killOrg = player.origin;
				deathInfo.killer = player;
				deathInfo.los = true;
				
				checkForSimilarDeaths(deathInfo);
				level.spawnlogic_deaths[level.spawnlogic_deaths.size] = deathInfo;
				*/
				
				if (getdvarint("scr_spawnpointdebug") > 0)
					line(player.origin + (0,0,50), spawnpoint.origin + (0,0,50), (.5,1,.5));
			}
			//else
			//	line(player.origin + (0,0,50), spawnpoint.origin + (0,0,50), (1,.5,.5));
		}

		prof_end("spawn_sight_checks");
	}
}

avoidVisibleEnemies(spawnpoints, teambased)
{
	if (getdvar("scr_spawnpointnewlogic") == "0") 
	{
		return;
	}

	// DEBUG
	prof_begin(" spawn_sc");

	lospenalty = 100000;
	if (getdvar("scr_spawnpointlospenalty") != "" && getdvar("scr_spawnpointlospenalty") != "0")
		lospenalty = getdvarfloat("scr_spawnpointlospenalty");

	otherteam = "axis";
	if ( self.pers["team"] == "axis" )
		otherteam = "allies";

	if ( teambased )
	{
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if ( !isdefined(spawnpoints[i].sights) )
				continue;
			
			penalty = lospenalty * spawnpoints[i].sights[otherteam];
			spawnpoints[i].weight -= penalty;
			
			/#
			if (level.storeSpawnData) {
				index = spawnpoints[i].sightChecks.size;
				spawnpoints[i].sightChecks[index] = spawnstruct();
				spawnpoints[i].sightChecks[index].penalty = penalty;
			}
			#/
		}
	}
	else
	{
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if ( !isdefined(spawnpoints[i].sights) )
				continue;

			penalty = lospenalty * spawnpoints[i].sights;
			spawnpoints[i].weight -= penalty;

			/#
			if (level.storeSpawnData) {
				index = spawnpoints[i].sightChecks.size;
				spawnpoints[i].sightChecks[index] = spawnstruct();
				spawnpoints[i].sightChecks[index].penalty = penalty;
			}
			#/
		}
	}
				
	// DEBUG
	prof_end(" spawn_sc");
}

avoidSpawnReuse(spawnpoints, teambased)
{
	// DEBUG
	if (getdvar("scr_spawnpointnewlogic") == "0") {
		return;
	}
	
	prof_begin(" spawn_reuse");

	time = getTime();
	
	maxtime = 10*1000;
	maxdistSq = 800 * 800;

	for (i = 0; i < spawnpoints.size; i++)
	{
		if (!isdefined(spawnpoints[i].lastspawnedplayer) || !isdefined(spawnpoints[i].lastspawntime) ||
			!isalive(spawnpoints[i].lastspawnedplayer))
			continue;

		if (spawnpoints[i].lastspawnedplayer == self) 
			continue;
		if (teambased && spawnpoints[i].lastspawnedplayer.pers["team"] == self.pers["team"]) 
			continue;
		
		timepassed = time - spawnpoints[i].lastspawntime;
		if (timepassed < maxtime)
		{
			distSq = distanceSquared(spawnpoints[i].lastspawnedplayer.origin, spawnpoints[i].origin);
			if (distSq < maxdistSq)
			{
				worsen = 1000 * (1 - distSq/maxdistSq) * (1 - timepassed/maxtime);
				spawnpoints[i].weight -= worsen;
				/#
				if (level.storeSpawnData)
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was recently used: -" + worsen;
				#/
			}
			else
				spawnpoints[i].lastspawnedplayer = undefined; // don't worry any more about this spawnpoint
		}
		else
			spawnpoints[i].lastspawnedplayer = undefined; // don't worry any more about this spawnpoint
	}

	prof_end(" spawn_reuse");
}

avoidSameSpawn(spawnpoints)
{
	// DEBUG
	if (getdvar("scr_spawnpointnewlogic") == "0") {
		return;
	}
	
	prof_begin(" spawn_samespwn");

	if (!isdefined(self.lastspawnpoint))
		return;
	
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (spawnpoints[i] == self.lastspawnpoint) 
		{
			spawnpoints[i].weight -= 50000; // (half as bad as a likely spawn kill)
			/#
			if (level.storeSpawnData)
				spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was last spawnpoint: -50000";
			#/
			break;
		}
	}
	
	prof_end(" spawn_samespwn");
}

// =============================================

add_to_array(array, ent)
{
	if(!isdefined(ent))
		return array;
		
	if(!isdefined(array))
		array[0] = ent;
	else
		array[array.size] = ent;
	
	return array;	
}

