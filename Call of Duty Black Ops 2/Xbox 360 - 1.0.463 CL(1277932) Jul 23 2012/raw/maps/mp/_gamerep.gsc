#include maps\mp\_utility;

init()
{	
	if ( !isGameRepEnabled() )
		return;

	if ( isGameRepInitialized() )
		return;
		
	game["gameRepInitialized"] = true;
	
	game["gameRep"]["players"] = [];
	game["gameRep"]["playerNames"] = [];
	game["gameRep"]["max"] = [];
	game["gameRep"]["playerCount"] = 0;
	
	gameRepInitializeParams();
}

isGameRepInitialized()
{
	if ( !isDefined( game["gameRepInitialized"] ) || !game["gameRepInitialized"] )
		return false;
		
	return true;
}

isGameRepEnabled()
{
	//if ( level.rankedMatch )
	//	return true;

	return false;
}

gameRepInitializeParams()
{
	// Parameter Names (for individual players)
	game["gameRep"]["params"] = [];
	game["gameRep"]["params"][0] = "totalTimePlayed";
	game["gameRep"]["params"][1] = "score";
	game["gameRep"]["params"][2] = "scorePerMin";	
	game["gameRep"]["params"][3] = "kills";
	game["gameRep"]["params"][4] = "deaths";
	game["gameRep"]["params"][5] = "killDeathRatio";
	game["gameRep"]["params"][6] = "plants";
	game["gameRep"]["params"][7] = "defuses";
	game["gameRep"]["params"][8] = "captures";
	game["gameRep"]["params"][9] = "defends";	
	game["gameRep"]["params"][10] = "tacticalInsertions";
	game["gameRep"]["params"][11] = "joinAttempts";
	game["gameRep"]["params"][12] = "xp";
	
	// New Param additions go here.
	
	// Parameters which we want to track, but not use for reporting. (for individual players)
	game["gameRep"]["ignoreParams"] = [];
	game["gameRep"]["ignoreParams"][0] = "totalTimePlayed";
	
	// Game limit parameters
	game["gameRep"]["gameLimit"] = [];
	game["gameRep"]["gameLimit"]["default"] = [];
	game["gameRep"]["gameLimit"]["tdm"] = [];
	game["gameRep"]["gameLimit"]["dm"] = [];
	game["gameRep"]["gameLimit"]["sd"] = [];
	game["gameRep"]["gameLimit"]["dom"] = [];
	game["gameRep"]["gameLimit"]["dem"] = [];
	game["gameRep"]["gameLimit"]["koth"] = [];
	game["gameRep"]["gameLimit"]["ctf"] = [];
	
	// Score
	game["gameRep"]["gameLimit"]["default"]["score"] = 10000;
	game["gameRep"]["gameLimit"]["tdm"]["score"] = 6000;
	game["gameRep"]["gameLimit"]["dom"]["score"] = 6500;
	game["gameRep"]["gameLimit"]["dem"]["score"] = 8000;
	game["gameRep"]["gameLimit"]["sd"]["score"] = 10000;
	
	// Score per min
	game["gameRep"]["gameLimit"]["default"]["scorePerMin"] = 1500;
	game["gameRep"]["gameLimit"]["tdm"]["scorePerMin"] = 800;
	game["gameRep"]["gameLimit"]["dm"]["scorePerMin"] = 600;
	game["gameRep"]["gameLimit"]["dom"]["scorePerMin"] = 600;
	game["gameRep"]["gameLimit"]["dem"]["scorePerMin"] = 500;
	game["gameRep"]["gameLimit"]["sd"]["scorePerMin"] = 1500;
	game["gameRep"]["gameLimit"]["sab"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["koth"]["scorePerMin"] = 750;

	// Kills
	game["gameRep"]["gameLimit"]["default"]["kills"] = 100;
	game["gameRep"]["gameLimit"]["tdm"]["kills"] = 75;
	game["gameRep"]["gameLimit"]["dom"]["kills"] = 100;
	game["gameRep"]["gameLimit"]["dem"]["kills"] = 100;
	game["gameRep"]["gameLimit"]["sd"]["kills"] = 24;
	
	// Deaths
	game["gameRep"]["gameLimit"]["default"]["deaths"] = 50;
	
	// KD Ratio
	game["gameRep"]["gameLimit"]["default"]["killDeathRatio"] = 30;
	game["gameRep"]["gameLimit"]["dm"]["killDeathRatio"] = 30;
	game["gameRep"]["gameLimit"]["sd"]["killDeathRatio"] = 12;
	
	// Kills per min
	game["gameRep"]["gameLimit"]["default"]["killsPerMin"] = 3;
	
	// Plants
	game["gameRep"]["gameLimit"]["default"]["plants"] = 30;
	
	// Defuses
	game["gameRep"]["gameLimit"]["default"]["defuses"] = 30;
	
	// Captures
	game["gameRep"]["gameLimit"]["default"]["captures"] = 30;
	
	// Defends
	game["gameRep"]["gameLimit"]["default"]["defends"] = 50;
	
	// Total Time played (in sec)
	game["gameRep"]["gameLimit"]["default"]["totalTimePlayed"] = 10 * 60; 
	game["gameRep"]["gameLimit"]["dom"]["totalTimePlayed"] = 10 * 60; 
	game["gameRep"]["gameLimit"]["dem"]["totalTimePlayed"] = 19 * 60;
	
	// Tactical Insertion use
	game["gameRep"]["gameLimit"]["default"]["tacticalInsertions"] = 40;

	// Join attempts
	game["gameRep"]["gameLimit"]["default"]["joinAttempts"] = 3;

	// XP
	game["gameRep"]["gameLimit"]["default"]["xp"] = 40000;

	// Splitscreen (total)
	game["gameRep"]["gameLimit"]["default"]["splitscreen"] = 8;
	
	// New Param Limits go here.
}

gameRepPlayerConnected()
{
	if ( !isGameRepEnabled() )
		return;

	name = self.name;
	if ( !isDefined( game["gameRep"]["players"][name] ) )
	{
		game["gameRep"]["players"][name] = [];
		
		for( j = 0; j < game["gameRep"]["params"].size; j++ )
		{
			paramName = game["gameRep"]["params"][j];
			game["gameRep"]["players"][name][paramName] = 0;
		}
	
		game["gameRep"]["players"][name]["splitscreen"] = self IsSplitScreen();
		game["gameRep"]["players"][name]["joinAttempts"] = 1;
		game["gameRep"]["players"][name]["connected"] = true;

		game["gameRep"]["playerNames"][ game["gameRep"]["playerCount"] ] = name;
		game["gameRep"]["playerCount"]++;
	}
	else
	{
		if ( !game["gameRep"]["players"][name]["connected"] )
		{
			game["gameRep"]["players"][name]["joinAttempts"]++;
			game["gameRep"]["players"][name]["connected"] = true;
		}
	}
}

gameRepPlayerDisconnected()
{
	if ( !isGameRepEnabled() )
		return;

	name = self.name;
	self gameRepUpdateNonPersistentPlayerInformation();
	self gameRepUpdatePersistentPlayerInformation();
	game["gameRep"]["players"][name]["connected"] = false;
}

gameRepUpdateNonPersistentPlayerInformation()
{
	name = self.name;
	
	game["gameRep"]["players"][name]["totalTimePlayed"] += self.timePlayed["total"];
	
	if ( isDefined( self.tacticalInsertionCount ) )
		game["gameRep"]["players"][name]["tacticalInsertions"] += self.tacticalInsertionCount;

	// New Non-Persistent Param Calculations go here.

	/*println( "gameRepUpdatePersistentPlayerInformation() for player " + name );
	paramName = "totalTimePlayed";
	println( "Param: " + paramName + "Value: " + getParamValueForPlayer( name, paramName ) );*/
	
}

gameRepUpdatePersistentPlayerInformation()
{
	name = self.name;
	if ( !isDefined( game["gameRep"]["players"][name] ) )
		return;
		
	if ( game["gameRep"]["players"][name]["totalTimePlayed"] != 0 )
		timePlayed = game["gameRep"]["players"][name]["totalTimePlayed"];
	else
		timePlayed = 1;
			
	game["gameRep"]["players"][name]["score"] += self.score;
	game["gameRep"]["players"][name]["scorePerMin"] = int( game["gameRep"]["players"][name]["score"] / ( timePlayed / 60 ) );
	
	game["gameRep"]["players"][name]["kills"] += self.kills;
	game["gameRep"]["players"][name]["deaths"] += self.deaths;
	
	if ( game["gameRep"]["players"][name]["deaths"] != 0 )
		game["gameRep"]["players"][name]["killDeathRatio"] = int( ( game["gameRep"]["players"][name]["kills"] / game["gameRep"]["players"][name]["deaths"] ) * 100 );
	else
		game["gameRep"]["players"][name]["killDeathRatio"] = game["gameRep"]["players"][name]["kills"] * 100 ;

	game["gameRep"]["players"][name]["plants"] += self.plants;
	game["gameRep"]["players"][name]["defuses"] += self.defuses;
	
	game["gameRep"]["players"][name]["captures"] += self.captures;
	game["gameRep"]["players"][name]["defends"] += self.defends;

	game["gameRep"]["players"][name]["xp"] += self.pers["summary"]["xp"];
	// New Persistent Param Calculations go here.
	
	/*println( "gameRepUpdatePersistentPlayerInformation() for player " + name );
	for ( j = 0; j < game["gameRep"]["params"].size; j++ )
	{
		paramName = game["gameRep"]["params"][j];
		if ( isGameRepParamValid( paramName ) )
			println( "Param: " + paramName + "Value: " + getParamValueForPlayer( name, paramName ) );
	}*/
}

getParamValueForPlayer( playerName, paramName )
{
	if ( isDefined( game["gameRep"]["players"][playerName][paramName] ) )
		return game["gameRep"]["players"][playerName][paramName];
		
	assertmsg( "Unknown parameter " + paramName + "for individual player" );
}

isGameRepParamValid( paramName )
{
	gametype = level.gametype;
	
	if ( !isDefined( game["gameRep"]["gameLimit"][gametype][paramName] ) && !isDefined( game["gameRep"]["gameLimit"]["default"][paramName] ) )
		return false;
		
	return true;
}

isGameRepParamIgnoredForReporting( paramName )
{
	if ( isDefined( game["gameRep"]["ignoreParams"][paramName] ) )
		return true;
		
	return false;
}

getGameRepParamLimit( paramName )
{
	gametype = level.gametype;
	
	if ( isDefined( game["gameRep"]["gameLimit"][gametype][paramName] ) )
		return game["gameRep"]["gameLimit"][gametype][paramName];
		
	if ( isDefined( game["gameRep"]["gameLimit"]["default"][paramName] ) )
		return game["gameRep"]["gameLimit"]["default"][paramName];
		
	assertmsg( "Default values for parameter " + paramName + " is not defined." );
}

setMaximumParamValueForCurrentGame( paramName, value )
{
	if ( !isDefined( game["gameRep"]["max"][paramName] ) )
	{
		game["gameRep"]["max"][paramName] = value;
		return;
	}
	
	if ( game["gameRep"]["max"][paramName] < value )
	{
		game["gameRep"]["max"][paramName] = value;
	}
}

gameRepUpdateInformationForRound()
{
	if ( !isGameRepEnabled() )
		return;

	// We will update only non persistent data between rounds.
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];	
		player gameRepUpdateNonPersistentPlayerInformation();
	}
}

gameRepAnalyzeAndReport()
{	
	if ( !isGameRepEnabled() )
		return;

	// Non persistent data is already updated at the end of the round. 
	// So, lets update only the persistent data for the current players.
	players = GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player gameRepUpdatePersistentPlayerInformation();
	}
	
	splitscreenPlayerCount = 0;
	// Set the maximums for this game (comparing for all players)
 	for ( i = 0; i < game["gameRep"]["playerNames"].size; i++ )
	{
		playerName = game["gameRep"]["playerNames"][i];
		
		// Individual Params
		for ( j = 0; j < game["gameRep"]["params"].size; j++ )
		{
			paramName = game["gameRep"]["params"][j];
			if ( isGameRepParamValid( paramName ) )
				setMaximumParamValueForCurrentGame( paramName, getParamValueForPlayer( playerName, paramName ) );
		}
		
		// Splitscreen Players count
		paramName = "splitscreen";
		splitscreenPlayerCount += getParamValueForPlayer( playerName, paramName );
		setMaximumParamValueForCurrentGame( paramName, splitscreenPlayerCount );
	}
	
	// Check if any of the params reached the maximum limit.
	// If any of them reaches the maximum limit, then we will prepare and report this film.
	for ( j = 0; j < game["gameRep"]["params"].size; j++ )
	{
		paramName = game["gameRep"]["params"][j];
		
		//println( "Param: " + paramName + " Max: " + game["gameRep"]["max"][paramName] + " Limit: " +  getGameRepParamLimit( paramName ) );
		if ( isGameRepParamValid( paramName ) && game["gameRep"]["max"][paramName] >= getGameRepParamLimit( paramName ) )
		{
			gameRepPrepareAndReportFilm();
			return;
		}
	}
	
	paramName = "splitscreen";
	if ( game["gameRep"]["max"][paramName] >= getGameRepParamLimit( paramName ) )
	{
		gameRepPrepareAndReportFilm();
		return;
	}
}

gameRepPrepareAndReportFilm( name )
{
	//println( "Prepare and reporting film" );
	
	// Column Index starts from 1 since 0 is reserved for the gamemode.
	columnIndex = 1;
	for ( j = 0; j < game["gameRep"]["params"].size; j++ )
	{
		paramName = game["gameRep"]["params"][j];
		
		if ( isGameRepParamIgnoredForReporting( paramName ) )
			continue;
			
		if ( isDefined( game["gameRep"]["max"][paramName] ) )
			reportFilm( columnIndex, game["gameRep"]["max"][paramName] );
		else
			reportFilm( columnIndex, 0 );
			
		columnIndex++;
			
		//println( "Report: " + paramName + " : " + game["gameRep"]["max"][paramName] );
	}
}