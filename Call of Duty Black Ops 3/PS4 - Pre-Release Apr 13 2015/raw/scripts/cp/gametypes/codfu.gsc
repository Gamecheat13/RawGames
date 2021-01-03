
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\_callbacks;//Registry
#using scripts\cp\_skipto;
#using scripts\cp\_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec ignore_systems()
{
	//shutdown unwanted systems - doing it in an autoexec is the only clean way to do it
	system::ignore("spawning");
	system::ignore("cybercom");
	system::ignore("healthoverlay");
	system::ignore("challenges");
	system::ignore("rank");
	system::ignore("hacker_tool");
	system::ignore("grapple");
	system::ignore("replay_gun");
	system::ignore("riotshield");
	system::ignore("teams");
	system::ignore("empgrenade");
	system::ignore("oed");
	system::ignore("explosive_bolt");
	system::ignore("empgrenade");
	system::ignore("bot");
}

function main()
{
	globallogic::init();

	level.gametype = toLower( GetDvarString( "g_gametype" ) );	
	
	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 0 );
	util::registerScoreLimit( 0, 0 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 0 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gametype, 15, 0, 1440 );

	level.scoreRoundWinBased = false;
	level.teamScorePerKill 			= 0;//GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath 		= 0;//GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot 		= 0;//GetGametypeSetting( "teamScorePerHeadshot" );
	level.teamBased 				= true;
	level.overrideTeamScore 		= true;
	level.onStartGameType 			= &onStartGameType;
	level.onSpawnPlayer 			= &onSpawnPlayer;
	level.onPlayerKilled	 		= &onPlayerKilled;
	level.playerMaySpawn 	 		= &may_player_spawn;
	level.gametypeSpawnWaiter 		= &wait_to_spawn;	

	level.disablePrematchMessages 	= true;
	level.endGameOnScoreLimit	 	= false;
	level.endGameOnTimeLimit 		= false;
	level.respawn_next_checkpoint 	= false;

	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
}

function onStartGameType()
{
	level.displayRoundEndText = false;
	allowed[0] = "coop";
	setClientNameMode("auto_change");

	game["switchedsides"] = false;
	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.playerteams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_COOP" );
		util::setObjectiveHintText( team, &"OBJECTIVES_COOP_HINT" );
		util::setObjectiveScoreText( team, &"OBJECTIVES_COOP" );

		spawnlogic::add_spawn_points( team, "cp_coop_spawn" );
		spawnlogic::add_spawn_points( team, "cp_coop_respawn" );
	}
		
	spawning::updateAllSpawnPoints();


	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	SetDvar("sv_botThinkType","BOT_THINKTYPE_CODFU");
	
	//removed action loop -CDC
	//level thread onScoreCloseMusic();
}

function onSpawnPlayer(predictedSpawn, question)
{
	self spawn( (0,0,0), (0,0,0), "coop" );
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
}

function wait_to_spawn()
{
	return true;
}

function may_player_spawn()
{
	return true;
}

