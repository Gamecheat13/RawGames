#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;

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
			load::main();

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

#precache( "string", "OBJECTIVES_TDM" );
#precache( "string", "OBJECTIVES_TDM_SCORE" );
#precache( "string", "OBJECTIVES_TDM_HINT" );
#precache( "string", "MP_PURGATORY_QUEUE_POSITION" );
#precache( "string", "MP_PURGATORY_NEXT_SPAWN" );
#precache( "string", "MP_PURGATORY_TEAMMATE_COUNT" );
#precache( "string", "MP_PURGATORY_ENEMY_COUNT" );
#precache( "string", "MP_ALL_TEAMS_ELIMINATED" );

function main()
{
	globallogic::init();

	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 10 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.cumulativeRoundScores = GetGametypeSetting( "cumulativeRoundScores" );
	level.teamBased = true;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onRoundEndGame =&onRoundEndGame;
	level.onRoundSwitch =&onRoundSwitch;
	level.onDeadEvent =&onDeadEvent;
	level.onLastTeamAliveEvent =&onLastTeamAliveEvent;
	level.onAliveCountChange =&onAliveCountChange;
	level.spawnMessage =&pur_spawnMessage;
	level.onSpawnSpectator =&onSpawnSpectator;
	level.onRespawnDelay =&getRespawnDelay;

	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	game["dialog"]["sudden_death"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
}

function onStartGameType()
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
	
	allowed[0] = "tdm";
	
	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.teams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_TDM" );
		util::setObjectiveHintText( team, &"OBJECTIVES_TDM_HINT" );
		
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_TDM" );
		}
		else
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_TDM_SCORE" );
		}
		
		spawnlogic::place_spawn_points( spawning::getTDMStartSpawnName(team) );
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
	}	

	spawning::updateAllSpawnPoints();

	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array(spawning::getTDMStartSpawnName(team));
	}
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
		
	level.displayRoundEndText = false;
	
	//removed action loop -CDC
	//level thread onScoreCloseMusic();

	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
		if( level.scoreRoundWinBased )
		{
			globallogic_score::resetTeamScores();
		}
	}
}

function waitThenSpawn()
{
	while( self.sessionstate == "dead" )
	{
		{wait(.05);};
	}
	
//	spawntime = 3;
//	util::setLowerMessage( game["strings"]["waiting_to_spawn"], spawntime );
	
	//wait(spawntime);
}

function onSpawnPlayerUnified(question)
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
		spawnteam = util::getOtherTeam( spawnteam );
	
	
	if ( isdefined( question ) ) 
		question = 1;
	if ( isdefined ( question ) )
		question = -1;
	
	
	if ( isdefined ( spawnTeam ) ) 
		spawnTeam = spawnTeam;
	if ( !isdefined ( spawnTeam ) )
		spawnTeam = -1;

	self util::clearLowerMessage();
	spawning::onSpawnPlayer_Unified();
}


function onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	initPlayerHud();
	
	spawnteam = self.pers["team"];
	
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
		spawnPoints = spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(spawnTeam) );
		
		if ( !spawnPoints.size )
			spawnPoints = spawnlogic::get_spawnpoint_array( spawning::getTeamStartSpawnName(spawnTeam, "mp_sab_spawn" ) );
			
		if ( !spawnPoints.size )
		{
			if ( game["switchedsides"] )
				spawnteam = util::getOtherTeam( spawnteam );

			spawnPoints = spawnlogic::get_team_spawnpoints( spawnteam );
			spawnPoint = spawnlogic::get_spawnpoint_near_team( spawnPoints );
		}
		else
		{
			spawnPoint = spawnlogic::get_spawnpoint_random( spawnPoints );
		}		
	}
	else
	{
		if ( game["switchedsides"] )
			spawnteam = util::getOtherTeam( spawnteam );

		spawnPoints = spawnlogic::get_team_spawnpoints( spawnteam );
		spawnPoint = spawnlogic::get_spawnpoint_near_team( spawnPoints );
	}
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self util::clearLowerMessage();

		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
}

function pur_endGameWithKillcam( winningTeam, endReasonText )
{
	thread globallogic::endGame( winningTeam, endReasonText );
}

function onAliveCountChange( team )
{
	level thread updateQueueMessage(team);
}

function onLastTeamAliveEvent( team )
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

function onDeadEvent( team )
{
	if ( team == "all" )
	{
		pur_endGameWithKillcam( "tie", game["strings"]["round_draw"] );
	}
}

function onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && isdefined( level.teams[winningTeam] ) )
		globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
}

function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];

	if ( level.scoreRoundWinBased ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	}
}

function onRoundEndGame( roundWinner )
{
	if ( level.scoreRoundWinBased ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	
		winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}

function onScoreCloseMusic()
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
	    thread globallogic_audio::set_music_on_team( "timeOut" );
	    return;
    }
      
    wait(1);
  }
}

function initPurgatoryEnemyCountElem( team, y_pos )
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

function initPlayerHud()
{
	if( isdefined( self.purPurgatoryCountElem ) )
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

function updatePlayerHud()
{
	self endon("disconnect");
	level endon("end_game");
	
	while (true )
	{
		if ( self.team != "spectator" )
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

function hidePlayerHudOnGameEnd(  )
{
	level waittill("game_ended");
	
	foreach( elem in self.purPurgatoryCountElem )
	{
		elem.alpha = 0;
	}
}

function displaySpawnMessage()
{
	if ( self.waitingToSpawn )
		return;
	
	if ( self.name == "TolucaLake" )
	{
		shit = 0;
	}
	
	//self util::setLowerMessage( &"MP_PURGATORY_QUEUE_POSITION", 100, true );
	if ( self.spawnQueueIndex != 0 )
	{
		self util::setLowerMessageValue( &"MP_PURGATORY_QUEUE_POSITION", self.spawnQueueIndex + 1, true );
	}
	else
	{
		self util::setLowerMessageValue( &"MP_PURGATORY_NEXT_SPAWN", undefined, false );
	}
}

function pur_spawnMessage()
{
	util::WaitTillSlowProcessAllowed();
	
	//self displaySpawnMessage();
}

function onSpawnSpectator( origin, angles )
{
	self displaySpawnMessage();
	
	globallogic_defaults::default_onSpawnSpectator( origin, angles );
}

function updateQueueMessage(team)
{
	self notify("updateQueueMessage");
	self endon("updateQueueMessage");
	
	util::WaitTillSlowProcessAllowed();
	
	players = level.deadPlayers[team];

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( !player.waitingToSpawn && player.sessionstate != "dead" && !isdefined( player.killcam ) )
		{
			player displaySpawnMessage();
		}
	}
}

function getRespawnDelay()
{
	self.lowerMessageOverride = undefined;
	
	return level.playerRespawnDelay;
}