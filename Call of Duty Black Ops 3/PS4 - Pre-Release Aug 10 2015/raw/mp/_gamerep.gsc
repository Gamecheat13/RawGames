    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\rank_shared;

#using scripts\shared\bots\_bot;

#namespace gamerep;

function init()
{	
	if ( !isGameRepEnabled() )
	{
		return;
	}

	if ( isGameRepInitialized() )
	{
		return;
	}
		
	game["gameRepInitialized"] = true;
	
	game["gameRep"]["players"] = [];
	game["gameRep"]["playerNames"] = [];
	game["gameRep"]["max"] = [];
	game["gameRep"]["playerCount"] = 0;
	
	gameRepInitializeParams();
}

function isGameRepInitialized()
{
	if ( !isdefined( game["gameRepInitialized"] ) || !game["gameRepInitialized"] )
		return false;
		
	return true;
}

function isGameRepEnabled()
{
	if( bot::is_bot_ranked_match() ) 
		return false;

	if ( !level.rankedMatch )
		return false;

	return true;
}

function gameRepInitializeParams()
{
	// this should match the thresholdExceeded_e in live_anticheat.cpp
	THRESHOLD_EXCEEDED_SCORE = 0;
	THRESHOLD_EXCEEDED_SCORE_PER_MIN = 1;
	THRESHOLD_EXCEEDED_KILLS = 2;
	THRESHOLD_EXCEEDED_DEATHS = 3;
	THRESHOLD_EXCEEDED_KD_RATIO = 4;
	THRESHOLD_EXCEEDED_KILLS_PER_MIN = 5;
	THRESHOLD_EXCEEDED_PLANTS = 6;
	THRESHOLD_EXCEEDED_DEFUSES = 7;
	THRESHOLD_EXCEEDED_CAPTURES = 8;
	THRESHOLD_EXCEEDED_DEFENDS = 9;
	THRESHOLD_EXCEEDED_TOTAL_TIME_PLAYED = 10;
	THRESHOLD_EXCEEDED_TACTICAL_INSERTION_USE = 11;
	THRESHOLD_EXCEEDED_JOIN_ATTEMPTS = 12;
	THRESHOLD_EXCEEDED_XP = 13;
	THRESHOLD_EXCEEDED_SPLITSCREEN = 14;

	// Parameter Names (for individual players)
	game["gameRep"]["params"] = [];

	game["gameRep"]["params"][0] = "score";
	game["gameRep"]["params"][1] = "scorePerMin";	
	game["gameRep"]["params"][2] = "kills";
	game["gameRep"]["params"][3] = "deaths";
	game["gameRep"]["params"][4] = "killDeathRatio";
	game["gameRep"]["params"][5] = "killsPerMin";	
	game["gameRep"]["params"][6] = "plants";
	game["gameRep"]["params"][7] = "defuses";
	game["gameRep"]["params"][8] = "captures";
	game["gameRep"]["params"][9] = "defends";
	game["gameRep"]["params"][10] = "totalTimePlayed";
	game["gameRep"]["params"][11] = "tacticalInsertions";
	game["gameRep"]["params"][12] = "joinAttempts";
	game["gameRep"]["params"][13] = "xp";

	// New Param additions go here.
	
	// Parameters which we want to track, but not use for reporting. (for individual players)
	game["gameRep"]["ignoreParams"] = [];
	game["gameRep"]["ignoreParams"][0] = "totalTimePlayed";
	
	// Game limit parameters
	game["gameRep"]["gameLimit"] = [];
	game["gameRep"]["gameLimit"]["default"] = [];
	game["gameRep"]["gameLimit"]["tdm"] = [];
	game["gameRep"]["gameLimit"]["dm"] = [];
	game["gameRep"]["gameLimit"]["dom"] = [];
	game["gameRep"]["gameLimit"]["hq"] = [];
	game["gameRep"]["gameLimit"]["sd"] = [];
	game["gameRep"]["gameLimit"]["dem"] = [];
	game["gameRep"]["gameLimit"]["ctf"] = [];
	game["gameRep"]["gameLimit"]["koth"] = [];
	game["gameRep"]["gameLimit"]["conf"] = [];

	// Score
	game["gameRep"]["gameLimit"]["id"]["score"] = THRESHOLD_EXCEEDED_SCORE;
	game["gameRep"]["gameLimit"]["default"]["score"] = 20000;
		
	// Score per min
	game["gameRep"]["gameLimit"]["id"]["scorePerMin"] = THRESHOLD_EXCEEDED_SCORE_PER_MIN;
	game["gameRep"]["gameLimit"]["default"]["scorePerMin"] = 250;
	game["gameRep"]["gameLimit"]["dem"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["tdm"]["scorePerMin"] = 700;
	game["gameRep"]["gameLimit"]["dm"]["scorePerMin"] = 950;
	game["gameRep"]["gameLimit"]["dom"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["sd"]["scorePerMin"] = 200;
	game["gameRep"]["gameLimit"]["ctf"]["scorePerMin"] = 600;
 	game["gameRep"]["gameLimit"]["hq"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["koth"]["scorePerMin"] = 1000;
	game["gameRep"]["gameLimit"]["conf"]["scorePerMin"] = 1000;

	// Kills
	game["gameRep"]["gameLimit"]["id"]["kills"] = THRESHOLD_EXCEEDED_KILLS;
	game["gameRep"]["gameLimit"]["default"]["kills"] = 75;
	game["gameRep"]["gameLimit"]["tdm"]["kills"] = 40;
	game["gameRep"]["gameLimit"]["sd"]["kills"] = 15;
	game["gameRep"]["gameLimit"]["dm"]["kills"] = 31;

	// Deaths
	game["gameRep"]["gameLimit"]["id"]["deaths"] = THRESHOLD_EXCEEDED_DEATHS;
	game["gameRep"]["gameLimit"]["default"]["deaths"] = 50;
	game["gameRep"]["gameLimit"]["dm"]["deaths"] = 15;
	game["gameRep"]["gameLimit"]["tdm"]["deaths"] = 40;
	
	// KD Ratio
	game["gameRep"]["gameLimit"]["id"]["killDeathRatio"] = THRESHOLD_EXCEEDED_KD_RATIO;
	game["gameRep"]["gameLimit"]["default"]["killDeathRatio"] = 30;
	game["gameRep"]["gameLimit"]["tdm"]["killDeathRatio"] = 50;
	game["gameRep"]["gameLimit"]["sd"]["killDeathRatio"] = 20;
	
	// Kills per min
	game["gameRep"]["gameLimit"]["id"]["killsPerMin"] = THRESHOLD_EXCEEDED_KILLS_PER_MIN;
	game["gameRep"]["gameLimit"]["default"]["killsPerMin"] = 15;

	// Plants
	game["gameRep"]["gameLimit"]["id"]["plants"] = THRESHOLD_EXCEEDED_PLANTS;
	game["gameRep"]["gameLimit"]["default"]["plants"] = 10;
	
	// Defuses
	game["gameRep"]["gameLimit"]["id"]["defuses"] = THRESHOLD_EXCEEDED_DEFUSES;
	game["gameRep"]["gameLimit"]["default"]["defuses"] = 10;
	
	// Captures
	game["gameRep"]["gameLimit"]["id"]["captures"] = THRESHOLD_EXCEEDED_CAPTURES;
	game["gameRep"]["gameLimit"]["default"]["captures"] = 30;
	
	// Defends
	game["gameRep"]["gameLimit"]["id"]["defends"] = THRESHOLD_EXCEEDED_DEFENDS;
	game["gameRep"]["gameLimit"]["default"]["defends"] = 50;
	
	// Total Time played (in sec)
	game["gameRep"]["gameLimit"]["id"]["totalTimePlayed"] = THRESHOLD_EXCEEDED_TOTAL_TIME_PLAYED;
	game["gameRep"]["gameLimit"]["default"]["totalTimePlayed"] = 10 * 60;
	game["gameRep"]["gameLimit"]["dom"]["totalTimePlayed"] = 10 * 60; 
	game["gameRep"]["gameLimit"]["dem"]["totalTimePlayed"] = 19 * 60;

	// Tactical Insertion use
	game["gameRep"]["gameLimit"]["id"]["tacticalInsertions"] = THRESHOLD_EXCEEDED_TACTICAL_INSERTION_USE;
	game["gameRep"]["gameLimit"]["default"]["tacticalInsertions"] = 20;

	// Join attempts
	game["gameRep"]["gameLimit"]["id"]["joinAttempts"] = THRESHOLD_EXCEEDED_JOIN_ATTEMPTS;
	game["gameRep"]["gameLimit"]["default"]["joinAttempts"] = 3;

	// XP
	game["gameRep"]["gameLimit"]["id"]["xp"] = THRESHOLD_EXCEEDED_XP;
	game["gameRep"]["gameLimit"]["default"]["xp"] = 25000;

	// Splitscreen (total)
	game["gameRep"]["gameLimit"]["id"]["splitscreen"] = THRESHOLD_EXCEEDED_SPLITSCREEN;
	game["gameRep"]["gameLimit"]["default"]["splitscreen"] = 8;
	
}

function gameRepPlayerConnected()
{
	if ( !isGameRepEnabled() )
		return;
		
	name = self.name;

	/#
	// println( "gameRepPlayerConnected() for player " + name );
	#/

	if ( !isdefined( game["gameRep"]["players"][name] ) )
	{
		game["gameRep"]["players"][name] = [];
		
		for( j = 0; j < game["gameRep"]["params"].size; j++ )
		{
			paramName = game["gameRep"]["params"][j];
			game["gameRep"]["players"][name][ paramName ] = 0;
		}
	
		game["gameRep"]["players"][name]["splitscreen"] = self IsSplitScreen();
		game["gameRep"]["players"][name]["joinAttempts"] = 1;
		game["gameRep"]["players"][name]["connected"] = true;
		game["gameRep"]["players"][name]["xpStart"] = self rank::getRankXpStat();

		game["gameRep"]["playerNames"][ game["gameRep"]["playerCount"] ] = name;
		game["gameRep"]["playerCount"]++;
	}
	else
	{
		if ( !game["gameRep"]["players"][name]["connected"] )
		{
			game["gameRep"]["players"][name]["joinAttempts"]++;
			game["gameRep"]["players"][name]["connected"] = true;
			game["gameRep"]["players"][name]["xpStart"] = self rank::getRankXpStat();
		}
	}
}

function gameRepPlayerDisconnected()
{
	if ( !isGameRepEnabled() )
		return;

	name = self.name;

	if( !isdefined( game["gameRep"]["players"][name] ) 
	|| !isdefined( self.pers["summary"] ) ) 
	{
		// we are probably migrating
		return;
	}

	/#
	// println( "gameRepPlayerDisconnected() for player " + name );
	#/

	self gameRepUpdateNonPersistentPlayerInformation();
	self gameRepUpdatePersistentPlayerInformation();
	game["gameRep"]["players"][name]["connected"] = false;
}

function gameRepUpdateNonPersistentPlayerInformation()
{
	name = self.name;
	if ( !isdefined( game["gameRep"]["players"][name] ) )
		return;
	
	game["gameRep"]["players"][name]["totalTimePlayed"] += self.timePlayed["total"];
	
	if ( isdefined( self.tacticalInsertionCount ) )
		game["gameRep"]["players"][name]["tacticalInsertions"] += self.tacticalInsertionCount;

	// New Non-Persistent Param Calculations go here.

	/*println( "gameRepUpdatePersistentPlayerInformation() for player " + name );
	paramName = "totalTimePlayed";
	println( "Param: " + paramName + "Value: " + getParamValueForPlayer( name, paramName ) );*/	
}

function gameRepUpdatePersistentPlayerInformation()
{
	name = self.name;
	if ( !isdefined( game["gameRep"]["players"][name] ) )
		return;
		
	if ( game["gameRep"]["players"][name]["totalTimePlayed"] != 0 )
		timePlayed = game["gameRep"]["players"][name]["totalTimePlayed"];
	else
		timePlayed = 1;
			
	game["gameRep"]["players"][name]["score"] = self.score;
	game["gameRep"]["players"][name]["scorePerMin"] = int( game["gameRep"]["players"][name]["score"] / ( timePlayed / 60 ) );
	
	game["gameRep"]["players"][name]["kills"] = self.kills;
	game["gameRep"]["players"][name]["deaths"] = self.deaths;
	
	if ( game["gameRep"]["players"][name]["deaths"] != 0 )
		game["gameRep"]["players"][name]["killDeathRatio"] = int( ( game["gameRep"]["players"][name]["kills"] / game["gameRep"]["players"][name]["deaths"] ) * 100 );
	else
		game["gameRep"]["players"][name]["killDeathRatio"] = game["gameRep"]["players"][name]["kills"] * 100;

	
	game["gameRep"]["players"][name]["killsPerMin"] = int( game["gameRep"]["players"][name]["kills"] / ( timePlayed / 60 ) );
	
	game["gameRep"]["players"][name]["plants"] = self.plants;
	game["gameRep"]["players"][name]["defuses"] = self.defuses;
	
	game["gameRep"]["players"][name]["captures"] = self.captures;
	game["gameRep"]["players"][name]["defends"] = self.defends;

	game["gameRep"]["players"][name]["xp"] = self rank::getRankXpStat() - game["gameRep"]["players"][name]["xpStart"];	
	game["gameRep"]["players"][name]["xpStart"] = self rank::getRankXpStat();

	// New Persistent Param Calculations go here.
	
	/*println( "gameRepUpdatePersistentPlayerInformation() for player " + name );
	for ( j = 0; j < game["gameRep"]["params"].size; j++ )
	{
		paramName = game["gameRep"]["params"][j];
		if ( isGameRepParamValid( paramName ) )
			println( "Param: " + paramName + "Value: " + getParamValueForPlayer( name, paramName ) );
	}*/
}

function getParamValueForPlayer( playerName, paramName )
{
	if ( isdefined( game["gameRep"]["players"][playerName][paramName] ) )
		return game["gameRep"]["players"][playerName][paramName];
		
	assertmsg( "Unknown parameter " + paramName + "for individual player" );
}

function isGameRepParamValid( paramName )
{
	gametype = level.gametype;

	if ( !isdefined( game["gameRep"] ) )
		return false;
	
	if ( !isdefined( game["gameRep"]["gameLimit"] ) )
		return false;

	if ( !isdefined( game["gameRep"]["gameLimit"][gametype] ) )
		return false;

	if ( !isdefined( game["gameRep"]["gameLimit"][gametype][paramName] ) )
		return false;

	if ( !isdefined( game["gameRep"]["gameLimit"][gametype][paramName] ) && !isdefined( game["gameRep"]["gameLimit"]["default"][paramName] ) )
		return false;
		
	return true;
}

function isGameRepParamIgnoredForReporting( paramName )
{
	if ( isdefined( game["gameRep"]["ignoreParams"][paramName] ) )
		return true;
		
	return false;
}

function getGameRepParamLimit( paramName )
{
	gametype = level.gametype;

	if ( isdefined( game["gameRep"]["gameLimit"][gametype] ) )
	{	
		if ( isdefined( game["gameRep"]["gameLimit"][gametype][paramName] ) )
			return game["gameRep"]["gameLimit"][gametype][paramName];
	}
		
	if ( isdefined( game["gameRep"]["gameLimit"]["default"][paramName] ) )
		return game["gameRep"]["gameLimit"]["default"][paramName];
		
	assertmsg( "Default values for parameter " + paramName + " is not defined." );
}

function setMaximumParamValueForCurrentGame( paramName, value )
{
	if ( !isdefined( game["gameRep"]["max"][paramName] ) )
	{
		game["gameRep"]["max"][ paramName ] = value;
		return;
	}
	
	if ( game["gameRep"]["max"][ paramName ] < value )
	{
		game["gameRep"]["max"][ paramName ] = value;
	}
}

function gameRepUpdateInformationForRound()
{
	if ( !isGameRepEnabled() )
		return;

	// We will update only non persistent data between rounds.
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];	
		player gameRepUpdateNonPersistentPlayerInformation();
	}
}

function gameRepAnalyzeAndReport()
{	
	if ( !isGameRepEnabled() )
		return;

	// Non persistent data is already updated at the end of the round. 
	// So, lets update only the persistent data for the current players.
	players = GetPlayers();
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
	}

	setMaximumParamValueForCurrentGame( paramName, splitscreenPlayerCount );
	
	// Check if any of the params reached the maximum limit.
	// If any of them reaches the maximum limit, then we will prepare and report this film.
	for ( j = 0; j < game["gameRep"]["params"].size; j++ )
	{
		paramName = game["gameRep"]["params"][j];
		
		//println( "Param: " + paramName + " Max: " + game["gameRep"]["max"][ paramName ] + " Limit: " +  getGameRepParamLimit( paramName ) );
		
		if ( isGameRepParamValid( paramName ) && game["gameRep"]["max"][ paramName ] >= getGameRepParamLimit( paramName ) )
		{
			gameRepPrepareAndReport( paramName );
		}
	}
	
	paramName = "splitscreen";
	if ( game["gameRep"]["max"][ paramName ] >= getGameRepParamLimit( paramName ) )
	{
		gameRepPrepareAndReport( paramName );
	}
}

function gameRepPrepareAndReport( paramName )
{
	if ( !isdefined( game["gameRep"]["gameLimit"]["id"][paramName] ) )
		return;

	if ( isGameRepParamIgnoredForReporting( paramName ) )
		return;

	gameRepThresholdExceeded( game["gameRep"]["gameLimit"]["id"][ paramName ] );
}
