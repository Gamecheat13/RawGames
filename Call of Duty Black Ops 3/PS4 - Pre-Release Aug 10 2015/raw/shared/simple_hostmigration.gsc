#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function Migration_SetupGameType()
{
	// Game Data
	game["roundMillisecondsAlreadyPassed"] = GetHostMigrationValue( "timePassed" );
	game["roundsplayed"] = GetHostMigrationValue( "roundsPlayed" );
	game["roundswon"]["tie"] = GetHostMigrationValue( "roundsTied" );
	
	// Team Related Data
	foreach( team in level.teams )
	{
		teamIndex = level.teamIndex[team];
		game["teamScores"][team] = GetHostMigrationValue( "team", teamIndex, "score" );
		game["roundswon"][team] = GetHostMigrationValue( "team", teamIndex, "roundsWon" );
	}
	
	// Player Data will be setup by player connect.
	game["reRegisterScoreInfo"] = true;
	game["migratedHost"] = true;
	
	thread Migration_OnPlayerConnect();
}

function Migration_GetIndexForPlayer( player )
{
	count = GetHostMigrationArrayCount( "player" );
	for ( i = 0; i < count; i++ )
	{
		migrationPlayerName = GetHostMigrationValue( "player", i, "name" );
		if ( player.name == migrationPlayerName )
		{
			return i;	
		}
	}
	
	return -1;
}

function Migration_SetupPlayerData( player, index )
{
	selectedClass = GetHostMigrationValue( "player", index, "currentClass" );
	if ( selectedClass != "" )
	{
		player closeInGameMenu();
		player.selectedClass = true;
		player [[level.curClass]](undefined,selectedClass);
	}
	
	player.pers["score"] = GetHostMigrationValue( "player", index, "score" );
	player.score = player.pers["score"];
	player.pers["momentum"] = GetHostMigrationValue( "player", index, "momentum" );
	player.momentum = player.pers["momentum"];
	player.pers["kills"] = GetHostMigrationValue( "player", index, "kills" );
	player.kills = player.pers["kills"];
	player.pers["deaths"] = GetHostMigrationValue( "player", index, "deaths" );
	player.deaths = player.pers["deaths"];
	player.pers["assists"] = GetHostMigrationValue( "player", index, "assists" );
	player.assists = player.pers["assists"];
	player.pers["defends"] = GetHostMigrationValue( "player", index, "defends" );
	player.defends = player.pers["defends"];
	player.pers["plants"] = GetHostMigrationValue( "player", index, "plants" );
	player.plants = player.pers["plants"];
	player.pers["defuses"] = GetHostMigrationValue( "player", index, "defuses" );
	player.defuses = player.pers["defuses"];
	player.pers["returns"] = GetHostMigrationValue( "player", index, "returns" );
	player.returns = player.pers["returns"];
	player.pers["captures"] = GetHostMigrationValue( "player", index, "captures" );
	player.captures = player.pers["captures"];
	player.pers["carries"] = GetHostMigrationValue( "player", index, "carries" );
	player.carries = player.pers["carries"];
	player.pers["disables"] = GetHostMigrationValue( "player", index, "disables" );
	player.disables = player.pers["disables"];
	player.pers["escorts"] = GetHostMigrationValue( "player", index, "escorts" );
	player.escorts = player.pers["escorts"];
	player.pers["throws"] = GetHostMigrationValue( "player", index, "throws" );
	player.throws = player.pers["throws"];	
	player.pers["killsconfirmed"] = GetHostMigrationValue( "player", index, "killsconfirmed" );
	player.killsconfirmed = player.pers["killsconfirmed"];
	player.pers["killsdenied"] = GetHostMigrationValue( "player", index, "killsdenied" );
	player.killsdenied = player.pers["killsdenied"];
	player.pers["cur_kill_streak"] = GetHostMigrationValue( "player", index, "cur_kill_streak" );
	player.pers["cur_total_kill_streak"] = GetHostMigrationValue( "player", index, "cur_total_kill_streak" );
}

function Migration_OnPlayerConnect()
{
	playerMigrationDone = [];
	
	for(;;)
	{
		level waittill( "connected", player );
		
		index = Migration_GetIndexForPlayer( player );
		
		if ( index < 0 )
		{
			/# PrintLn("**** Migration_GetIndexForPlayer() - Unable to find index for player: " + player.name );	#/
			continue;
		}
		
		// TODO: add some method to just shutdown this thread instead of keeping it alive after migration.
		if ( isDefined( playerMigrationDone[index] ) )
			continue;
	
		Migration_SetupPlayerData( player, index );
		playerMigrationDone[index] = true;
	}
	
}

function Migration_WriteGameData()
{
	// Initialize the data
	if ( !isdefined( game["migration"]["gameData"] ) )
	{
		game["migration"]["gameData"] = [];
		
		game["migration"]["gameData"]["timePassed"] = 0;
		game["migration"]["gameData"]["roundsPlayed"] = 0;
		game["migration"]["gameData"]["roundsTied"] = 0;
	}
	
	gameData = game["migration"]["gameData"];
	
	// Time Passed
	newTimePassed = [[level.getTimePassed]]();
	if ( gameData["timePassed"] != newTimePassed ) 
	{
		SetHostMigrationValue( "timePassed", [[level.getTimePassed]]() );
		gameData["timePassed"] = newTimePassed;
	}
	
	// Rounds Played
	if ( isDefined( game["roundsplayed"] ) && gameData["roundsPlayed"] != game["roundsplayed"] ) 
	{
		SetHostMigrationValue( "roundsPlayed", game["roundsplayed"] );
		gameData["roundsPlayed"] = game["roundsplayed"];
	}
	
	// Rounds Tied
	if ( isDefined( game["roundswon"]["tie"] ) && gameData["roundsTied"] != game["roundswon"]["tie"] ) 
	{
		SetHostMigrationValue( "roundsTied", game["roundswon"]["tie"] );
		gameData["roundsTied"] = game["roundswon"]["tie"];
	}
}

function Migration_WriteTeamData( team )
{
	// Initialize the data
	if ( !isdefined( game["migration"]["teamData"] ) )
	{
		game["migration"]["teamData"] = [];
	}
	
	if ( !isdefined( game["migration"]["teamData"][team] ) )
	{
		game["migration"]["teamData"][team] = [];

		game["migration"]["teamData"][team]["score"] = 0;
		game["migration"]["teamData"][team]["roundsWon"] = 0;
	}
	
	teamData = game["migration"]["teamData"][team];
	teamIndex = level.teamIndex[team];
	
	if ( isDefined( game["teamScores"][team] ) && teamData["score"] != game["teamScores"][team] ) 
	{
		SetHostMigrationValue( "team", teamIndex, "score", game["teamScores"][team] );
		teamData["score"] = game["teamScores"][team];
	}
	
	if ( isDefined( game["roundswon"][team] ) && teamData["roundsWon"] != game["roundswon"][team] ) 
	{
		SetHostMigrationValue( "team", teamIndex, "roundsWon", game["roundswon"][team] );
		teamData["roundsWon"] = game["roundswon"][team];
	}	
}

function Migration_WritePlayerData( player, i ) 
{
	// Initialize the data
	if ( !isdefined( game["migration"]["playerData"] ) )
	{
		game["migration"]["playerData"] = [];
	}
	
	if ( !isdefined(game["migration"]["playerData"][i] ) )
	{
		game["migration"]["playerData"][i] = [];

		game["migration"]["playerData"][i]["name"] = "";
	    game["migration"]["playerData"][i]["currentClass"] = "";
	    game["migration"]["playerData"][i]["score"] = 0;
	    game["migration"]["playerData"][i]["momentum"] = 0;
	    game["migration"]["playerData"][i]["kills"] = 0;
	    game["migration"]["playerData"][i]["deaths"] = 0;
	    game["migration"]["playerData"][i]["assists"] = 0;
	    game["migration"]["playerData"][i]["defends"] = 0;
	    game["migration"]["playerData"][i]["plants"] = 0;
	    game["migration"]["playerData"][i]["defuses"] = 0;
	    game["migration"]["playerData"][i]["returns"] = 0;
	    game["migration"]["playerData"][i]["captures"] = 0;
	    game["migration"]["playerData"][i]["carries"] = 0;
	    game["migration"]["playerData"][i]["throws"] = 0;
	    game["migration"]["playerData"][i]["disables"] = 0;
	    game["migration"]["playerData"][i]["escorts"] = 0;
	    game["migration"]["playerData"][i]["killsconfirmed"] = 0;
	    game["migration"]["playerData"][i]["killsdenied"] = 0;
	    game["migration"]["playerData"][i]["cur_kill_streak"] = 0;
	    game["migration"]["playerData"][i]["cur_total_kill_streak"] = 0;
	}
	
	playerData = game["migration"]["playerData"][i];

	// Name			
	if ( player.name != playerData["name"] )
	{
	  	SetHostMigrationValue( "player", i, "name", player.name );
		playerData["name"] = player.name;
	}
	
	// Current Class
	if ( isdefined( player.pers["class"] ) && player.pers["class"] != playerData["currentClass"] )
	{
		SetHostMigrationValue( "player", i, "currentClass", player.pers["class"] );
		playerData["currentClass"] = player.pers["class"];
	}
	
	// Score			
	if ( player.score != playerData["score"] )
	{
	  	SetHostMigrationValue( "player", i, "score", player.score );
		playerData["score"] = player.score;
	}
	
	// Momentum
	if ( isdefined( player.pers["momentum"] ) && player.pers["momentum"] != playerData["momentum"] )
	{
		SetHostMigrationValue( "player", i, "momentum", player.pers["momentum"] );
		playerData["momentum"] = player.pers["momentum"];
	}
	
	// Kills
	if ( player.kills != playerData["kills"] )
	{
	  	SetHostMigrationValue( "player", i, "kills", player.kills );
		playerData["kills"] = player.kills;
	}
	
	// deaths
	if ( player.deaths != playerData["deaths"] )
	{
	  	SetHostMigrationValue( "player", i, "deaths", player.deaths );
		playerData["deaths"] = player.deaths;
	}
	
	// assists
	if ( player.assists != playerData["assists"] )
	{
	  	SetHostMigrationValue( "player", i, "assists", player.assists );
		playerData["assists"] = player.assists;
	}
	
	// defends
	if ( player.defends != playerData["defends"] )
	{
	  	SetHostMigrationValue( "player", i, "defends", player.defends );
		playerData["defends"] = player.defends;
	}
	
	// plants
	if ( player.plants != playerData["plants"] )
	{
	  	SetHostMigrationValue( "player", i, "plants", player.plants );
		playerData["plants"] = player.plants;
	}
	
	// defuses
	if ( player.defuses != playerData["defuses"] )
	{
	  	SetHostMigrationValue( "player", i, "defuses", player.defuses );
		playerData["defuses"] = player.defuses;
	}
	
	// disables
	if ( player.disables != playerData["disables"] )
	{
	  	SetHostMigrationValue( "player", i, "disables", player.disables );
		playerData["disables"] = player.disables;
	}
	
	// escorts
	if ( player.escorts != playerData["escorts"] )
	{
	  	SetHostMigrationValue( "player", i, "escorts", player.escorts );
		playerData["escorts"] = player.escorts;
	}
	
	// returns
	if ( player.returns != playerData["returns"] )
	{
	  	SetHostMigrationValue( "player", i, "returns", player.returns );
		playerData["returns"] = player.returns;
	}
	
	// captures
	if ( player.captures != playerData["captures"] )
	{
	  	SetHostMigrationValue( "player", i, "captures", player.captures );
		playerData["captures"] = player.captures;
	}
	
	// carries
	if ( player.carries != playerData["carries"] )
	{
	  	SetHostMigrationValue( "player", i, "carries", player.carries );
		playerData["carries"] = player.carries;
	}
	
	// throws
	if ( player.throws != playerData["throws"] )
	{
	  	SetHostMigrationValue( "player", i, "throws", player.throws );
		playerData["trhows"] = player.throws;
	}
	
	// killsconfirmed
	if ( player.killsconfirmed != playerData["killsconfirmed"] )
	{
	  	SetHostMigrationValue( "player", i, "killsconfirmed", player.killsconfirmed );
		playerData["killsconfirmed"] = player.killsconfirmed;
	}
	
	// killsdenied
	if ( player.killsdenied != playerData["killsdenied"] )
	{
	  	SetHostMigrationValue( "player", i, "killsdenied", player.killsdenied );
		playerData["killsdenied"] = player.killsdenied;
	}	
	
	// cur_kill_streak
	if ( isdefined( player.pers["cur_kill_streak"] ) && player.pers["cur_kill_streak"] != playerData["cur_kill_streak"] )
	{
		SetHostMigrationValue( "player", i, "cur_kill_streak", player.pers["cur_kill_streak"] );
		playerData["cur_kill_streak"] = player.pers["cur_kill_streak"];
	}
	
	// cur_total_kill_streak
	if ( isdefined( player.pers["cur_total_kill_streak"] ) && player.pers["cur_total_kill_streak"] != playerData["cur_total_kill_streak"] )
	{
		SetHostMigrationValue( "player", i, "cur_total_kill_streak", player.pers["cur_total_kill_streak"] );
		playerData["cur_total_kill_streak"] = player.pers["cur_total_kill_streak"];
	}
}

function UpdateHostmigrationData()
{	
	level endon( "game_ended" );

	if ( !isdefined( game["migration"] ) )
	{
		game["migration"] = [];
	}

	while ( game["state"] == "playing" )
	{
		Migration_WriteGameData();
		
		// Team Related Data
		foreach( team in level.teams )
		{	
			Migration_WriteTeamData( team );
		}
		
		// Player Related Data
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			
			Migration_WritePlayerData( player, i );
		}
		wait 1;
	}
}