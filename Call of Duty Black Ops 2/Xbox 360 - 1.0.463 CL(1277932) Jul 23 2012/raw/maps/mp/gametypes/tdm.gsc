#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	TDM - Team Deathmatch
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
			game["team3"] = "guys_who_hate_both_other_teams";
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

/*QUAKED mp_tdm_spawn_team1_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_team2_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_team3_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_team4_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_team5_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_team6_start (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
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
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onPlayerKilled = ::onPlayerKilled;

	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
}

getTeamStartSpawnName( team )
{
		spawn_point_team_name = team;
		
		// for multi-team using slightly different start spawns for axis and allies
		if ( level.multiTeam )
		{
			if ( team == "axis" )
			 	spawn_point_team_name = "team1";
			else if ( team == "allies" )
			 	spawn_point_team_name = "team2";
		}
		
		return "mp_tdm_spawn_" + spawn_point_team_name + "_start" ;
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
		
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_tdm_spawn" );

		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( getTeamStartSpawnName(team) );
	}
		
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();

	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray( getTeamStartSpawnName(team) );
	}
	
	// TODO MTEAM remove this hack once we get start spawns for team5-8
	if ( level.multiTeam )
	{
		foreach( team in level.teams )
		{
			if ( level.spawn_start[team].size == 0 )
			{
				// let them use the main tdm spawns
				level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn");
			}
		}
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

onSpawnPlayerUnified(question)
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod && !level.playerQueuedRespawn )
	{
		level.useStartSpawns = false;
	}
	
	spawnteam = self.pers["team"];
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

	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	spawnteam = self.pers["team"];
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
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( getTeamStartSpawnName(spawnTeam) );
		
		// TODO MTEAM - remove this when we get team7-8 spawns
		if ( spawnteam == "team7" || spawnteam == "team8")
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_axis_start" );
		}
		
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
		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
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

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isPlayer( attacker ) == false || attacker.team == self.team )
		return;

	attacker maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( attacker.team, 1 );
}
