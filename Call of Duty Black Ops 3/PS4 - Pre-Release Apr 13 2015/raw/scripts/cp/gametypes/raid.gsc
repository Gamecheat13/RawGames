
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\sm\_sm;
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_round_manager;

#using scripts\cp\_callbacks;//Registry
#using scripts\cp\_skipto;
#using scripts\cp\_util;

/*
	RAID - Campaign RAID mode
	Objective: 	Complete each level
	Map ends:	When player reached eand of level
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		cp_coop_spawn
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

/*QUAKED cp_coop_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Player spawn positions.*/

/*QUAKED cp_coop_respawn (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Player respawn positions.*/

/*

// COOP GAMEPLAY CONFIGURATION SETTINGS

  // When one player dies 
    // These only apply when there are other living players so they have no effect in solo games
	// if none of these are set (and there are other living players), players will just respawn when they die
	
	// Dead players will remain in intermission mode until the next checkpoint is reached
	level.respawn_next_checkpoint=true;

	// Dead players will remain in intermission mode for a fixed amount of time 
	//   If the checkpoint flag above is also set the time will be applied after the checkpoint is reached
	
	// time to spend in intermission between lives
	level.respawn_intermission_time = 3;
	// increasing this much with each death
	level.respawn_intermission_increment = 3;

  // When all players die 
	// if none of these are set, players will just respawn when they die 
	// end the mission and exit to the front end when everyone is dead
	level.end_mission_all_dead=false;
	// restart the mission from the start when everyone is dead
	level.restart_mission_all_dead=false;
	// restart the mission from the last checkpoint when everyone is dead
	level.restart_checkpoint_all_dead=true;
 
*/











	






#precache( "string", "OBJECTIVES_COOP" );
#precache( "string", "OBJECTIVES_COOP_HINT" );

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

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.teamScorePerKill = GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerDeath = GetGametypeSetting( "teamScorePerDeath" );
	level.teamScorePerHeadshot = GetGametypeSetting( "teamScorePerHeadshot" );
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPlayerKilled =&onPlayerKilled;
	level.gametypeSpawnWaiter = &wait_to_spawn;	
	level.onEndGame =&onEndGame;
	level.intermission_override_func = &after_action_report_intermission;
	
	level.disablePrematchMessages = true;
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;

	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;

	game["dialog"]["gametype"] = "coop_start";
	game["dialog"]["gametype_hardcore"] = "hccoop_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
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
	
	allowed[0] = "coop";
	
	level.displayRoundEndText = false;
	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	foreach( team in level.teams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_COOP" );
		util::setObjectiveHintText( team, &"OBJECTIVES_COOP_HINT" );
		util::setObjectiveScoreText( team, &"OBJECTIVES_COOP" );
		spawnlogic::add_spawn_points( team, "cp_coop_spawn" );
	}
	
	level.useStartSpawns = false;
	spawning::updateAllSpawnPoints();

/*
	// used for show spawn debugging
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array( spawning::getTDMStartSpawnName(team) );
	}
*/

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
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

function onSpawnPlayerUnified(question)
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod && !level.playerQueuedRespawn )
	{
		level.useStartSpawns = false;
	}

	spawning::onSpawnPlayer_Unified();
}

function onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && isdefined( level.teams[winningTeam] ) )
		globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
	
	side_mission::on_end_game( winningTeam );
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

function wait_to_spawn()
{
	if ( ( isdefined( level.inPrematchPeriod ) && level.inPrematchPeriod ) )
		return true;	
	
	if ( may_player_spawn() )
		return true;
		
	level waittill("sm_respawn_spectators");

	return true;
}

function may_player_spawn()
{
	return self side_mission::may_player_spawn( );
}

// Function to display the AAR instead of the intermission screen at the end of the level
function after_action_report_intermission()
{
	wait( 1 );
	show_aar_menu();
}

//*****************************************************************************
//*****************************************************************************

#precache( "lui_menu", "Rewards" );					// Precache the menu you open using "lui_"
#precache( "menu", "AfterActionReportMenu" );		// Precache the menu you "respond to" this way

	// Wait for all players to exit the AAR?


function show_aar_menu()
{
	level.num_player_exits = 0;

	players = GetPlayers();	
	foreach( player in players )
	{
		if( 1 )
		{
			player thread aar_menu_wait();
		}
		else
		{
			player aar_menu_wait();
		}
	}

	if( 1 )
	{
		start_time = gettime();
		while( level.num_player_exits < players.size )
		{
			// Break out after time
			time = gettime();
			dt = ( time - start_time ) / 1000;
			if( dt > 8 )
			{
				break;
			}
			{wait(.05);};
		}
	}
}

// self = player
function aar_menu_wait()
{
	rewardsMenu = self OpenLUIMenu( "Rewards" );
	self waittill( "menuresponse", menu, response );

	// IPrintLnBold( menu + ": " + response );			// should print “AfterActionReportMenu: done”

	level thread BlackScreen( 0, 100, 3 );
	level.num_player_exits++;
}

// Misc black screen function
function BlackScreen(fadein, stay, fadeout)
{
	level endon("unloaded");
	blackscreen = NewHudElem();
	
	blackscreen.alpha = 0;
	blackscreen.horzAlign = "fullscreen";
	blackscreen.vertAlign = "fullscreen";
	
	//blackscreen thread CleanupOnDeath(blackscreen);
	
	blackscreen SetShader( "black", 640, 480 );
	if( fadein > 0 )
	{
		blackscreen fadeOverTime( fadein ); 
	}
	blackscreen.alpha = 1;

	wait (stay);
	
	if( fadeout > 0 )
	{
		blackscreen fadeOverTime( fadeout ); 
	}
	blackscreen.alpha = 0;	
	
	blackscreen destroy();
}

