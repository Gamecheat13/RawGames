#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	PUR - Purgatory
	Objective: 	Score points for your team by eliminating players on the opposing team
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerRoundSwitch( 0, 9 );
	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 50000 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundBased = ( GetGametypeSetting( "roundscorecarry" ) == false );
	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onDeadEvent = ::onDeadEvent;
	level.onLastTeamAliveEvent = ::onLastTeamAliveEvent;
	level.onAliveCountChange =::onAliveCountChange;
	level.spawnMessage =	::pur_spawnMessage;
	level.onSpawnSpectator = ::onSpawnSpectator;
	level.onRespawnDelay = ::getRespawnDelay;

	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	game["dialog"]["sudden_death"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
}

onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	PreCacheString( &"MP_PURGATORY_QUEUE_POSITION" );
	PreCacheString( &"MP_PURGATORY_NEXT_SPAWN" );
	PreCacheString( &"MP_PURGATORY_TEAMMATE_COUNT" );
	PreCacheString( &"MP_PURGATORY_ENEMY_COUNT" );
	PreCacheString( &"MP_ALL_TEAMS_ELIMINATED" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.teams )
	{
		setObjectiveText( team, &"OBJECTIVES_TDM" );
		setObjectiveHintText( team, &"OBJECTIVES_TDM_HINT" );
		
		if ( level.splitscreen )
		{
			setObjectiveScoreText( team, &"OBJECTIVES_TDM" );
		}
		else
		{
			setObjectiveScoreText( team, &"OBJECTIVES_TDM_SCORE" );
		}
		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_" + team + "_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_tdm_spawn" );
	}	

	maps\mp\gametypes\_spawning::updateAllSpawnPoints();

	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_" + team + "_start");
	}
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	allowed[0] = "tdm";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	
	//removed action loop -CDC
	//level thread onScoreCloseMusic();

	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}
}

waitThenSpawn()
{
	while( self.sessionstate == "dead" )
	{
		wait (0.05);
	}
	
//	spawntime = 3;
//	setLowerMessage( game["strings"]["waiting_to_spawn"], spawntime );
	
	//wait(spawntime);
}

onSpawnPlayerUnified(question)
{
	self endon( "disconnect" );
	level endon( "end_game" );
	
	self.usingObj = undefined;
	
//	if ( level.useStartSpawns && !level.inGracePeriod )
//	{
//		level.useStartSpawns = false;
//	}
	
	self initPlayerHud();

	self waitThenSpawn();
	
	spawnteam = self.pers["team"];
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );
	
	
	if ( isdefined( question ) ) 
		question = 1;
	if ( isdefined ( question ) )
		question = -1;
	
	
	if ( isdefined ( spawnTeam ) ) 
		spawnTeam = spawnTeam;
	if ( !isdefined ( spawnTeam ) )
		spawnTeam = -1;

	self clearLowerMessage();
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	initPlayerHud();
	
	spawnteam = self.pers["team"];
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );
	
	if ( isdefined( question ) ) 
		question = 1;
	if ( isdefined ( question ) )
		question = -1;
	
	
	if ( isdefined ( spawnTeam ) ) 
		spawnTeam = spawnTeam;
	if ( !isdefined ( spawnTeam ) )
		spawnTeam = -1;

	
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + spawnteam + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self clearLowerMessage();

		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
}

pur_endGameWithKillcam( winningTeam, endReasonText )
{
	level thread maps\mp\gametypes\_killcam::startLastKillcam();
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

onAliveCountChange( team )
{
	level thread updateQueueMessage(team);
}

onLastTeamAliveEvent( team )
{
	if (level.multiTeam )
	{
		pur_endGameWithKillcam( team, &"MP_ALL_TEAMS_ELIMINATED" );
	}
	else if ( team == game["attackers"] )
	{
		pur_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		pur_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
}

onDeadEvent( team )
{
	if ( team == "all" )
	{
		pur_endGameWithKillcam( "tie", game["strings"]["round_draw"] );
	}
}

onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && isdefined( level.teams[winningTeam] ) )
		maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
}

onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];

	if ( level.roundScoreCarry == false ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	}
}

onRoundEndGame( roundWinner )
{
	if ( level.roundScoreCarry == false ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}

onScoreCloseMusic()
{
	teamScores = [];
	
  while( !level.gameEnded )
  {
    scoreLimit = level.scoreLimit;
    scoreThreshold = scoreLimit * .1;
    scoreThresholdStart = abs(scoreLimit - scoreThreshold);
    scoreLimitCheck = scoreLimit - 10;

		topScore = 0;
		runnerUpScore = 0;
  	foreach( team in level.teams )
  	{
	    score = [[level._getTeamScore]]( team );
	    
	    if ( score > topScore )
	    {
	    	runnerUpScore = topScore;
	    	topScore = score;
	    }
	    else if ( score > runnerUpScore )
	    {
	    	runnerUpScore = score;
	    }
	  }
 
    scoreDif = (topScore - runnerUpScore);
            
    if ( scoreDif <= scoreThreshold && scoreThresholdStart <= topScore )
    {
	    //play some action music and break the loop
	    thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
	    thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
	    return;
    }
      
    wait(1);
  }
}

initPurgatoryEnemyCountElem( team, y_pos )
{
	self.purPurgatoryCountElem[team] = newclienthudelem( self );
	self.purPurgatoryCountElem[team].fontScale = 1.25;
	self.purPurgatoryCountElem[team].x = 110;
	self.purPurgatoryCountElem[team].y = y_pos; 
	self.purPurgatoryCountElem[team].alignX = "right";
	self.purPurgatoryCountElem[team].alignY = "top";
	self.purPurgatoryCountElem[team].horzAlign = "left";
	self.purPurgatoryCountElem[team].vertAlign = "top";
	self.purPurgatoryCountElem[team].foreground = true;
	self.purPurgatoryCountElem[team].hidewhendead = false;
	self.purPurgatoryCountElem[team].hidewheninmenu = true;
	self.purPurgatoryCountElem[team].archived = false;
	self.purPurgatoryCountElem[team].alpha = 1.0;
	self.purPurgatoryCountElem[team].label = &"MP_PURGATORY_ENEMY_COUNT";
}

initPlayerHud()
{
	if( isDefined( self.purPurgatoryCountElem ) )
	{
		if ( self.pers["team"] == self.purHudTeam )
			return;
			
		foreach( elem in self.purPurgatoryCountElem )
		{
			elem destroy();
		}
	}

	self.purPurgatoryCountElem = [];

	y_pos = 115;
	y_inc = 15;
	
	team = self.pers["team"];
	self.purHudTeam = team;
	
	self.purPurgatoryCountElem[team] = newclienthudelem( self );
	self.purPurgatoryCountElem[team].fontScale = 1.25;
	self.purPurgatoryCountElem[team].x = 110;
	self.purPurgatoryCountElem[team].y = y_pos; 
	self.purPurgatoryCountElem[team].alignX = "right";
	self.purPurgatoryCountElem[team].alignY = "top";
	self.purPurgatoryCountElem[team].horzAlign = "left";
	self.purPurgatoryCountElem[team].vertAlign = "top";
	self.purPurgatoryCountElem[team].foreground = true;
	self.purPurgatoryCountElem[team].hidewhendead = false;
	self.purPurgatoryCountElem[team].hidewheninmenu = true;
	self.purPurgatoryCountElem[team].archived = false;
	self.purPurgatoryCountElem[team].alpha = 1.0;
	self.purPurgatoryCountElem[team].label = &"MP_PURGATORY_TEAMMATE_COUNT";
	
	
	foreach( team in level.teams )
	{
		if ( team == self.team )
			continue;
			
		y_pos += y_inc;
		
		initPurgatoryEnemyCountElem(team, y_pos);
	}
	
	self thread hidePlayerHudOnGameEnd();	
	self thread updatePlayerHud();
}

updatePlayerHud()
{
	self endon("disconnect");
	level endon("end_game");
	
	while (true )
	{
		if ( self.team != "specator" )
		{
			self.purPurgatoryCountElem[self.team] setvalue( level.deadPlayers[self.team].size );
			
			foreach( team in level.teams )
			{
				if ( self.team == team )
					continue;
					
				self.purPurgatoryCountElem[team] setvalue( level.aliveCount[team] );
			}
		}
		wait(0.25);
	}
}

hidePlayerHudOnGameEnd(  )
{
	level waittill("game_ended");
	
	foreach( elem in self.purPurgatoryCountElem )
	{
		elem.alpha = 0;
	}
}

displaySpawnMessage()
{
	if ( self.waitingToSpawn )
		return;
	
	if ( self.name == "TolucaLake" )
	{
		shit = 0;
	}
	
	//self setLowerMessage( &"MP_PURGATORY_QUEUE_POSITION", 100, true );
	if ( self.spawnQueueIndex != 0 )
	{
		self setLowerMessageValue( &"MP_PURGATORY_QUEUE_POSITION", self.spawnQueueIndex + 1, true );
	}
	else
	{
		self setLowerMessageValue( &"MP_PURGATORY_NEXT_SPAWN", undefined, false );
	}
}

pur_spawnMessage()
{
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	//self displaySpawnMessage();
}

onSpawnSpectator( origin, angles )
{
	self displaySpawnMessage();
	
	maps\mp\gametypes\_globallogic_defaults::default_onSpawnSpectator( origin, angles );
}

updateQueueMessage(team)
{
	self notify("updateQueueMessage");
	self endon("updateQueueMessage");
	
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	players = level.deadPlayers[team];

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !player.waitingToSpawn && player.sessionstate != "dead" && !isDefined( player.killcam ) )
		{
			player displaySpawnMessage();
		}
	}
}

getRespawnDelay()
{
	self.lowerMessageOverride = undefined;
	
	return level.playerRespawnDelay;
}