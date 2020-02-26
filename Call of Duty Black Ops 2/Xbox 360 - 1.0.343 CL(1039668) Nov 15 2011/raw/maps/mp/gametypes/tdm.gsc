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
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
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

	maps\mp\gametypes\_globallogic_utils::registerTimeLimitDvar( "tdm", 10, 0, 1440 );
	maps\mp\gametypes\_globallogic_utils::registerScoreLimitDvar( "tdm", 7500, 0, 50000 );
	maps\mp\gametypes\_globallogic_utils::registerRoundLimitDvar( "tdm", 1, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerRoundWinLimitDvar( "tdm", 0, 0, 10 );
	maps\mp\gametypes\_globallogic_utils::registerNumLivesDvar( "tdm", 0, 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundBased = true;
	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;

	game["dialog"]["gametype"] = "tdm_start";
	game["dialog"]["gametype_hardcore"] = "hctdm_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "kills", "deaths", "kdratio", "assists" ); 
}

onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_TDM" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_TDM" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );
	}
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_TDM_HINT" );
	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_TDM_HINT" );
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();

	level.spawn_axis_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_axis_start");
	level.spawn_allies_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_allies_start");
	
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

onSpawnPlayerUnified()
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + self.pers["team"] + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + self.pers["team"] + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
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
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}

onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	
	return winner;
}

onScoreCloseMusic()
{
    while( !level.gameEnded )
    {
        axisScore = [[level._getTeamScore]]( "axis" );
	    alliedScore = [[level._getTeamScore]]( "allies" );
	    scoreLimit = level.scoreLimit;
	    scoreThreshold = scoreLimit * .1;
	    scoreDif = abs(axisScore - alliedScore);
	    scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	    scoreLimitCheck = scoreLimit - 10;
        
        if (alliedScore > axisScore)
	    {
		    currentScore = alliedScore;
	    }		
	    else
	    {
		    currentScore = axisScore;
	    }
        
        if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore )
	    {
		    //play some action music and break the loop
		    thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
		    thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
		    return;
	    }
        
        wait(.5);
    }
}
