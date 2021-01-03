
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\_callbacks;//Registry
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_bb;
#using scripts\cp\_laststand;
#using scripts\shared\music_shared;


	
#precache( "lui_menu", "CPMissionFailed" );
#precache( "lui_menu_data", "MissionFailReason" );
#precache( "lui_menu_data", "MissionFailHint" );
	
/*
	COOP - Campaign COOP mode
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
	level.onSpawnPlayer = &onSpawnPlayer;
	level.onSpawnPlayerUnified = undefined;
	level.onPlayerKilled =&onPlayerKilled;
	level.gametypeSpawnWaiter = &wait_to_spawn;	
	level.gametypeSpawnedAsSpectator = &spawnedAsSpectator;
	level.onPlayerBleedout = &onPlayerBleedout;	

  	// When all players die 
		// if none of these are set, players will just stay in last stand forever
	
	// end the mission and exit to the front end when everyone is dead
	level.end_mission_all_dead=false;
	// restart the mission from the start when everyone is dead
	level.restart_mission_all_dead=false;
	// restart the mission from the last checkpoint when everyone is dead
	level.restart_checkpoint_all_dead=true;
	
	level thread checkpointFadeIn();
	
	level.disablePrematchMessages = true;
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;
	level.respawn_next_checkpoint = false;

	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;

	gameobjects::register_allowed_gameobject( level.gameType );

	game["dialog"]["gametype"] = "coop_start";
	game["dialog"]["gametype_hardcore"] = "hccoop_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "assists", "incaps", "revives" ); 
}

function disableInvulverabilityAfter( time )	// self = player
{
	self endon( "death_or_disconnect" );
	wait time;
	self DisableInvulnerability();
}

function checkpointFadeIn()
{
	while( 1 )
	{
		level waittill( "save_restore" );
		
		music::setmusicstate ("death");	// simply an empty state that does not play the exit asset of ending state	
				
		Util::CleanupActorCorpses();
		
		level thread lui::screen_fade( 1.25, 0, 1, "black", true );
		
		foreach( player in level.players )
		{
			if ( player.sessionstate == "spectator" )
			{
				if( !isdefined( player.curClass ) )
				{
					player thread globallogic_ui::beginClassChoice();
				}
				else
				{
					player thread globallogic_spawn::waitAndSpawnClient();
				}
			}
			else if ( player laststand::player_is_in_laststand() )
	        {
	            player notify( "auto_revive" ); // currently CP only
	        }

			// Short invulnerable after checkpoint restart
			wasInvulnerableAlready = player EnableInvulnerability();
			if( !wasInvulnerableAlready )	// another script already had the player invulnverable, let it be
			{
				player thread disableInvulverabilityAfter( 3.0 );
			}
		}
	}
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
	
	level.displayRoundEndText = false;
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	foreach( team in level.playerteams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_COOP" );
		util::setObjectiveHintText( team, &"OBJECTIVES_COOP_HINT" );
		util::setObjectiveScoreText( team, &"OBJECTIVES_COOP" );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level thread respawn_spectators_on_objective_change();
		
	spawnlogic::add_spawn_points( "allies", "cp_coop_spawn" );
	spawning::updateAllSpawnPoints();
	
	level flag::wait_till( "first_player_spawned" );
	
	if ( !level flagsys::get( "level_has_skiptos" ) )
	{
		// For joining and respawning players, use all spawn points
	
		spawnlogic::clear_spawn_points();
		spawnlogic::add_spawn_points( "allies", "cp_coop_spawn" );
		spawnlogic::add_spawn_points( "allies", "cp_coop_respawn" );
		spawning::updateAllSpawnPoints();
	}
	
	foreach (player in level.players)
	{
		bb::logobjectivestatuschange("_level", player, "start");
	}
}

function onSpawnPlayer( predictedSpawn = false, question )
{
	PixBeginEvent( "COOP:onSpawnPlayer" );
	
	self.usingObj = undefined;

	if ( isdefined( question ) )
	{
		question = 1;
	}
	
	if ( isdefined ( question ) )
	{
		question = -1;
	}
	
	spawnPoint = spawning::getSpawnPoint( self, predictedSpawn );
	
	if ( predictedSpawn )
	{
		self PredictSpawnPoint( spawnPoint[ "origin" ], spawnPoint[ "angles" ] );
		self.predicted_spawn_point = spawnPoint;
	}
	else
	{
		self Spawn( spawnPoint[ "origin" ], spawnPoint[ "angles" ], "coop" );
	}
	
	PixEndEvent();
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
	attacker globallogic_score::giveTeamScoreForObjective( attacker.team, level.teamScorePerKill );
	self globallogic_score::giveTeamScoreForObjective( self.team, level.teamScorePerDeath * -1 );
	if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
	{
		attacker globallogic_score::giveTeamScoreForObjective( attacker.team, level.teamScorePerHeadshot );
	}
	
	// COOP - if you died in solo its over.  Time to restart from checkpoint.
	if ( level.players.size == 1 && !( isdefined( level.is_safehouse ) && level.is_safehouse ) )
	{
		if( ( isdefined( level.useFPSDeathCam ) && level.useFPSDeathCam ) && level.players.size == 1)
		{
			self waittill("cp_playercam_ended");
		}
		
		if ( ( isdefined( level.useCPKillcam ) && level.useCPKillcam ) )
		{
			self waittill( "end_killcam" );
		}
		
		fadeOutAndLoadCheckpoint();
	}
}

function fadeOutAndLoadCheckpoint( str_reason_for_fail, str_hint_to_not_fail )
{
	foreach( player in level.players )
	{
		player SetClientUIVisibilityFlag( "hud_visible", 0 );
		bb::logobjectivestatuschange(level.skipto_point, player, "restart");
		
		player util::freeze_player_controls(true);
		
		player.RestoringCheckPoint = true;
		
		// Need at least one string to show for the fail reason
		if( isdefined( str_reason_for_fail ) )
		{	
			// Show the mission fail screen
			player.mission_fail_menu = player OpenLUIMenu( "CPMissionFailed" );
			player SetLUIMenuData( player.mission_fail_menu, "MissionFailReason", str_reason_for_fail );
			
			// If we don't have a fail hint, don't show anything.
			if (!isdefined(str_hint_to_not_fail))
			{
				str_hint_to_not_fail = "";
			}
			
			player SetLUIMenuData( player.mission_fail_menu, "MissionFailHint", str_hint_to_not_fail );
		}
	}
	
	wait 3.8;
	
	if( ( isdefined( level.gameEnded ) && level.gameEnded ) )
	{
		wait 1000;
	}
	
	// Ensure we've freed up player controls, just as a precaution.
	foreach( player in level.players )
	{
		player util::freeze_player_controls(false);
	}
	
	CheckpointRestore();
			
	wait 0.5;	// CheckpointRestore does nothing if there wasn't one commited so do a map restart
	map_restart();
}

function onPlayerBleedout()
{
	foreach( player in level.players )
	{
		if ( player != self && player.sessionstate != "dead" && player.sessionstate != "spectator" && !( isdefined( player.laststand ) && player.laststand ) )
		{
			return;
		}
	}

	// EVERYBODY IS DEAD
	if ( ( isdefined( ( (GetDVarInt("coop_restart_checkpoint_all_dead")>=0) ? (GetDVarInt("coop_restart_checkpoint_all_dead")) : level.restart_checkpoint_all_dead ) ) && ( (GetDVarInt("coop_restart_checkpoint_all_dead")>=0) ? (GetDVarInt("coop_restart_checkpoint_all_dead")) : level.restart_checkpoint_all_dead ) ) )
	{
		if ( !( isdefined( level.level_ending ) && level.level_ending ) ) 
		{
			fadeOutAndLoadCheckpoint();
		}
		level.level_ending = true;
	}
	
	
	if ( ( isdefined( ( (GetDVarInt("coop_end_mission_all_dead")>=0) ? (GetDVarInt("coop_end_mission_all_dead")) : level.end_mission_all_dead ) ) && ( (GetDVarInt("coop_end_mission_all_dead")>=0) ? (GetDVarInt("coop_end_mission_all_dead")) : level.end_mission_all_dead ) ) )
	{
		if ( !( isdefined( level.level_ending ) && level.level_ending ) ) 
			MissionFailed();
		level.level_ending = true;
	}
	if ( ( isdefined( ( (GetDVarInt("coop_restart_mission_all_dead")>=0) ? (GetDVarInt("coop_restart_mission_all_dead")) : level.restart_mission_all_dead ) ) && ( (GetDVarInt("coop_restart_mission_all_dead")>=0) ? (GetDVarInt("coop_restart_mission_all_dead")) : level.restart_mission_all_dead ) ) )
	{
		skipto::use_default_skipto();
		if ( !( isdefined( level.level_ending ) && level.level_ending ) ) 
			map_restart();
		level.level_ending = true;
	}
	
/#	
	if ( !( isdefined( level.level_ending ) && level.level_ending ) ) 
	{
		ErrorMsg("Everybody is dead, but we aren't doing anything about it.");
	}
#/	
	
}

function wait_to_spawn()
{
	self notify("wait_to_spawn_singleton");
	self endon("wait_to_spawn_singleton");
	
	if ( ( isdefined( level.is_safehouse ) && level.is_safehouse ) || ( isdefined( level.inPrematchPeriod ) && level.inPrematchPeriod ) || !isdefined( self.completedInitialSpawn ) )
	{
		self.completedInitialSpawn = true;
		return true;
	}
	
	if ( self IsSplitscreen() )
		util::setLowerMessage( game["strings"]["waiting_to_spawn_ss"], 15.0, true );
	else
		util::setLowerMessage( game["strings"]["waiting_to_spawn"], 15.0 );
	
	level util::waittill_any_timeout( 15.0, "objective_changed");

	return true;
}



function respawn_spectators_on_objective_change()
{
	level flag::wait_till( "all_players_spawned" );
	while(1)
	{
		level waittill("objective_changed");
		foreach( player in level.players )
		{
			if ( player.sessionstate == "spectator" )
			{
				player globallogic_spawn::waitAndSpawnClient();
			}
		}
	}
}


function spawnedAsSpectator()
{
	if ( !isdefined( self.completedInitialSpawn ) )
		return true;
	return false;
}
