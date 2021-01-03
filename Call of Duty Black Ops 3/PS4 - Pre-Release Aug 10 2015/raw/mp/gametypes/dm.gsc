#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;

/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

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

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

#precache( "string", "OBJECTIVES_DM" );
#precache( "string", "OBJECTIVES_DM_SCORE" );
#precache( "string", "OBJECTIVES_DM_HINT" );

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 0, 0, 1440 );

	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.teamScorePerKill = GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath = GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot = GetGametypeSetting( "teamScorePerHeadshot" );
	level.onStartGameType =&onStartGameType;
	level.onPlayerKilled =&onPlayerKilled;

	gameobjects::register_allowed_gameobject( level.gameType );
	
	globallogic_audio::set_leader_gametype_dialog ( "startFreeForAll", "hcStartFreeForAll", "gameBoost", "gameBoost" );

	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "headshots", "score" ); 
}

function setupTeam( team )
{
	util::setObjectiveText( team, &"OBJECTIVES_DM" );
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( team, &"OBJECTIVES_DM" );
	}
	else
	{
		util::setObjectiveScoreText( team, &"OBJECTIVES_DM_SCORE" );
	}
	util::setObjectiveHintText( team, &"OBJECTIVES_DM_HINT" );

	spawnlogic::add_spawn_points( team, "mp_dm_spawn" );
	spawnlogic::place_spawn_points( "mp_dm_spawn_start" );
	
	level.spawn_start = spawnlogic::get_spawnpoint_array( "mp_dm_spawn_start" );

}

function onStartGameType()
{
	setClientNameMode("auto_change");

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.teams )
	{
		setupTeam( team );
	}

	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.displayRoundEndText = false;
	
	level thread onScoreCloseMusic();

	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
	}
}

function onEndGame( winningPlayer )
{
	if ( isdefined( winningPlayer ) && isPlayer( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, winningPlayer [[level._getPlayerScore]]() + 1 );
}

function onScoreCloseMusic()
{
    while( !level.gameEnded )
    {
        scoreLimit = level.scoreLimit;
	    scoreThreshold = scoreLimit * .9;
        
        for(i=0;i<level.players.size;i++)
        {
            scoreCheck = [[level._getPlayerScore]]( level.players[i] );
            
            if( scoreCheck >= scoreThreshold )
            {
                thread globallogic_audio::set_music_on_team( "timeOut" );
                return;
            }
        }
        
        wait(.5);
    }
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || ( self == attacker ) )
		return;

	attacker globallogic_score::givePointsToWin( level.teamScorePerKill );
	self globallogic_score::givePointsToWin( level.teamScorePerDeath * -1 );
	if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
	{
		attacker globallogic_score::givePointsToWin( level.teamScorePerHeadshot );
	}
}
