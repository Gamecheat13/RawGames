
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

/*
#define DVAR_OR_LEVELVAR(dvar,levelvar) ( (GetDVarInt(dvar)>=0) ? (GetDVarInt(dvar)) : levelvar )
#define FDVAR_OR_LEVELVAR(dvar,levelvar) ( (GetDVarFloat(dvar)>=0) ? (GetDVarFloat(dvar)) : levelvar )

#define RESPAWN_NEXT_CHECKPOINT 		DVAR_OR_LEVELVAR("coop_respawn_next_checkpoint",level.respawn_next_checkpoint)	
#define RESPAWN_INTERMISSION_TIME 		DVAR_OR_LEVELVAR("coop_respawn_intermission_time",level.respawn_intermission_time)	
#define RESPAWN_INTERMISSION_INCREMENT 	FDVAR_OR_LEVELVAR("coop_respawn_intermission_increment",level.respawn_intermission_increment)	

#define HOTJOIN_NEXT_CHECKPOINT 		DVAR_OR_LEVELVAR("coop_hotjoin_next_checkpoint",level.hotjoin_next_checkpoint)	
#define HOTJOIN_INTERMISSION_TIME 		DVAR_OR_LEVELVAR("coop_hotjoin_intermission_time",level.hotjoin_intermission_time)	
#define HOTJOIN_INTERMISSION_INCREMENT 	(0)
	
#define END_MISSION_ALL_DEAD 			DVAR_OR_LEVELVAR("coop_end_mission_all_dead",level.end_mission_all_dead)	
#define RESTART_MISSION_ALL_DEAD 		DVAR_OR_LEVELVAR("coop_restart_mission_all_dead",level.restart_mission_all_dead)	
#define RESTART_CHECKPOINT_ALL_DEAD 	DVAR_OR_LEVELVAR("coop_restart_checkpoint_all_dead",level.restart_checkpoint_all_dead)	

#define HOTJOIN_TEST_FLAG 				"start_coop_logic"

#precache( "string", "OBJECTIVES_COOP" );
#precache( "string", "OBJECTIVES_COOP_HINT" );
*/

function autoexec ignore_systems()
{
    //shutdown unwanted systems - doing it in an autoexec is the only clean way to do it
    system::ignore("cybercom");
    system::ignore("healthoverlay");
    system::ignore("challenges");
    system::ignore("rank");
    system::ignore("hacker_tool");
    system::ignore("grapple");
    system::ignore("replay_gun");
    system::ignore("riotshield");
    system::ignore("oed");
    system::ignore("explosive_bolt");
    system::ignore("empgrenade");
	system::ignore("spawning");	
	system::ignore("save");	
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

	level.scoreRoundWinBased 			= false;
	level.teamScorePerKill 			= 0;//GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath 		= 0;//GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot 		= 0;//GetGametypeSetting( "teamScorePerHeadshot" );
	level.teamBased 				= true;
	level.overrideTeamScore 		= true;
	level.onStartGameType 			=&onStartGameType;
	level.onSpawnPlayer 			=&onSpawnPlayer;
	level.onPlayerKilled	 		=&onPlayerKilled;
	level.playerMaySpawn 	 		= &may_player_spawn;
	level.gametypeSpawnWaiter 		= &wait_to_spawn;	

	level.disablePrematchMessages 	= true;
	level.endGameOnScoreLimit	 	= false;
	level.endGameOnTimeLimit 		= false;
	level.respawn_next_checkpoint 	= false;

	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;
	level.onEndGame = &onEndGame;
	
	gameobjects::register_allowed_gameobject( "coop" );

	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "gems","donations" ); 
}

function onStartGameType()
{
	level.displayRoundEndText = false;
	setClientNameMode("auto_change");

	game["switchedsides"] = false;
	
	// now that the game objects have been deleted place the influencers
//	spawning::create_map_placed_influencers();
	
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
	
	//removed action loop -CDC
	//level thread onScoreCloseMusic();
}

function onSpawnPlayer(predictedSpawn, question)
{
	pixbeginevent("COOP:onSpawnPlayer");
//self spawn( self.origin, self.angles, "coop" );
	pixendevent();
}

function onEndGame( winningTeam )
{
	ExitLevel( false );	//back to lobby
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

