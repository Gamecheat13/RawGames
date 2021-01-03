#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_teamops;

#using scripts\mp\_util;

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

#precache( "string", "OBJECTIVES_TDM" );
#precache( "string", "OBJECTIVES_TDM_SCORE" );
#precache( "string", "OBJECTIVES_TDM_HINT" );

function main()
{
	globallogic::init();

	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.teamScorePerKill = GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath = GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot = GetGametypeSetting( "teamScorePerHeadshot" );
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onRoundEndGame =&onRoundEndGame;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPlayerKilled =&onPlayerKilled;

	globallogic_audio::set_leader_gametype_dialog ( 14, 29, 36, 36 );
	
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
	
	level.displayRoundEndText = false;
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
		
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );

		
		spawnlogic::place_spawn_points( spawning::getTDMStartSpawnName(team) );
	}
		
	spawning::updateAllSpawnPoints();
	
/#
	// used for show spawn debugging
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(team) );
	}
#/

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	
	
	//removed action loop -CDC
	level thread onScoreCloseMusic();

	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
		if( level.scoreRoundWinBased )
		{
			globallogic_score::resetTeamScores();
		}
	}
}

function onSpawnPlayerUnified(question)
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod && !level.playerQueuedRespawn )
	{
		level.useStartSpawns = false;
	}
	
	spawnteam = self.pers["team"];
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

	spawning::onSpawnPlayer_Unified();
}


function onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	if ( isdefined( question ) ) 
		question = 1;
	if ( isdefined ( question ) )
		question = -1;
	
	spawnTeam = self.pers["team"];
	
	if ( isdefined ( spawnTeam ) ) 
		spawnTeam = spawnTeam;
	if ( !isdefined ( spawnTeam ) )
		spawnTeam = -1;

	
	if ( level.inGracePeriod )
	{
		spawnPoints = spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(spawnTeam) );
		
		if ( !spawnPoints.size )
			spawnPoints = spawnlogic::get_spawnpoint_array( spawning::getTeamStartSpawnName(spawnteam, "mp_sab_spawn" ) );
			
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
		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
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
            
//    if ( scoreDif <= scoreThreshold && scoreThresholdStart <= topScore )
//    {
//	    //play some action music and break the loop
//	    thread globallogic_audio::set_music_on_team( "timeOut" );
//	    return;
//    }

	if( topScore >= scoreLimit*.5)
	{
		level notify( "sndMusicHalfway" );
		return;
	}
      
    wait(1);
  }
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isPlayer( attacker ) == false || attacker.team == self.team )
		return;

	attacker globallogic_score::giveTeamScoreForObjective( attacker.team, level.teamScorePerKill );
	self globallogic_score::giveTeamScoreForObjective( self.team, level.teamScorePerDeath * -1 );
	if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
	{
		attacker globallogic_score::giveTeamScoreForObjective( attacker.team, level.teamScorePerHeadshot );
	}
}
