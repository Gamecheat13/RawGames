#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;

#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_popups;
#using scripts\mp\_util;

/*
	Freerun
	Objective: 	Make it to the goal the fastest
	Map ends:	When player quits
	Respawning:	Instant

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
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

/*
	- down is reset to active checkpoint 
	- left/right change courses
	- up is to reset to start of course/reset timer
*/

/* TODO: 

	- top 3 scores show on track end
	- timer based missile swarm that penalizes being on foot for too long
	- random missile swarm that chooses areas the player is running towards
	- timer value counting up every frame and incremented 5s on fault (or just add the faults at the end maybe)
	- combo/speed boost methods for stringing together special moves?
	- drop the ctf spawn point FX on the start and end triggers
	- UI NEEDS
		- timer
		- top 3
		- communication string billboard
		- track/difficulty callout	
		- press X to start gate

	- BUGS
		- find a way to unbind score board from script or CFG maybe
			- has to happen after binds are loaded from HD
*/

#precache( "string", "OBJECTIVES_FR" );
#precache( "string", "OBJECTIVES_FR_SCORE" );
#precache( "string", "OBJECTIVES_FR_HINT" );
#precache( "string", "OBJECTIVES_FR_NEW_RECORD" );
#precache( "string", "OBJECTIVES_FR_CHECKPOINT" );
#precache( "string", "OBJECTIVES_FR_FAULT" );
#precache( "string", "OBJECTIVES_FR_FAULTS" );
#precache( "string", "OBJECTIVES_FR_RETRY" );
#precache( "string", "OBJECTIVES_FR_RETRIES" );

#precache( "lui_menu", "T7Hud_FR" );
#precache( "lui_menu_data", "numFaults" );
#precache( "lui_menu_data", "numRetries" );









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
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onPlayerKilled =&onPlayerKilled;
	level.giveCustomLoadout = &giveCustomLoadout;

	game["dialog"]["gametype"] = "suddendeath";
	game["dialog"]["gametype_hardcore"] = "suddendeath";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";

	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "headshots", "score" ); 

	level.FRGame = SpawnStruct();

	level.FRGame.activeTrackIndex = 1;
	level.FRGame.tracks = [];
	
	for ( i = 0; i < 3; i++ )
	{
		level.FRGame.tracks[i] = SpawnStruct();

		level.FRGame.tracks[i].startTrigger = GetEnt( "fr_start_0" + i, "targetname" );
		assert( IsDefined( level.FRGame.tracks[i].startTrigger ));

		level.FRGame.tracks[i].goalTrigger = GetEnt( "fr_end_0" + i, "targetname" );
		assert( IsDefined( level.FRGame.tracks[i].goalTrigger ));

		level.FRGame.tracks[i].highScores = [];
	}

	level.FRGame.checkpointTriggers = GetEntArray( "fr_checkpoint", "targetname" );
	assert( level.FRGame.checkpointTriggers.size );

	spawns = spawnlogic::get_spawnpoint_array( "mp_dm_spawn" );
	
	for ( i = 0; i < level.FRGame.checkpointTriggers.size; i++ )
	{
		level.FRGame.checkpointTriggers[i] thread watchCheckpointTrigger();

		closest = 99999999;
		for ( j = 0; j < spawns.size; j++ )
		{
			dist = DistanceSquared( spawns[j].origin, level.FRGame.checkpointTriggers[i].origin );
			if ( dist < closest )
			{
				closest = dist;
				level.FRGame.checkpointTriggers[i].spawnPoint = spawns[j];
			}
		}

		assert( IsDefined( level.FRGame.checkpointTriggers[i].spawnPoint ));
	}

	player_starts = getentarray("info_player_start", "classname");
	assert( player_starts.size );

	for ( i = 0; i < level.FRGame.tracks.size; i++ )
	{
		closest = 99999999;
		for ( j = 0; j < player_starts.size; j++ )
		{
			dist = DistanceSquared( player_starts[j].origin, level.FRGame.tracks[i].startTrigger.origin );
			if ( dist < closest )
			{
				closest = dist;
				level.FRGame.tracks[i].playerStart = player_starts[j];
			}
		}

		assert( IsDefined( level.FRGame.tracks[i].playerStart ));
	}

	level.FRGame.deathTriggers = GetEntArray( "fr_die", "targetname" );
	assert( level.FRGame.deathTriggers.size );

	for ( i = 0; i < level.FRGame.deathTriggers.size; i++ )
	{
		level.FRGame.deathTriggers[i] thread watchDeathTrigger();
	}

	clientfield::register( "world", "freerun_restart", 1, 1, "int" );
		
	if(!IsDefined (level.freerun)) // this keeps suspense music from the global mp system from playing
	{
		level.freerun = "true";	
	}
}

function setupTeam( team )
{
	util::setObjectiveText( team, &"OBJECTIVES_FR" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( team, &"OBJECTIVES_FR" );
	}
	else
	{
		util::setObjectiveScoreText( team, &"OBJECTIVES_FR_SCORE" );
	}
	util::setObjectiveHintText( team, &"OBJECTIVES_FR_SCORE" );

	spawnlogic::add_spawn_points( team, "mp_dm_spawn" );
}

function onStartGameType()
{
	setClientNameMode("auto_change");

	allowed[0] = "dm";
	gameobjects::main(allowed);

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
	
	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	level.displayRoundEndText = false;
	
	level thread onScoreCloseMusic();

	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
	}	
}


function onSpawnPlayerUnified() // self == player
{
	spawning::onSpawnPlayer_Unified();

	level.FRGame.HUDMenu = self OpenLUIMenu( "T7Hud_FR" );

	self thread activateTrack( level.FRGame.activeTrackIndex );
	self thread watchTrackSwitch();
}

function onSpawnPlayer(predictedSpawn)
{
	spawnPoints = spawnlogic::get_team_spawnpoints( self.pers["team"] );
	spawnPoint = spawnlogic::get_spawnpoint_dm( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "dm" );
	}
}

function updateHighScores() // self == player
{
	best_time_0 = getBestTimeStatForTrack( level.FRGame.activeTrackIndex );		
	best_time_1 = 0;
	best_time_2 = 0;
	
	if ( level.FRGame.activeTrack.highScores.size > 0 )
	{
		best_time_0 = level.FRGame.activeTrack.highScores[0].finishTime;

		if ( IsDefined( level.FRGame.activeTrack.highScores[1] ))
		{
			best_time_1 = level.FRGame.activeTrack.highScores[1].finishTime;
		}

		if ( IsDefined( level.FRGame.activeTrack.highScores[2] ))
		{
			best_time_2 = level.FRGame.activeTrack.highScores[2].finishTime;
		}
	}
	
	self FreerunSetHighScores( best_time_0, best_time_1, best_time_2 );
}

function activateTrack( trackIndex ) // self == player
{
	level notify( "activate_track" );

	IPrintLn( "Track " + trackIndex );	

	if ( level clientfield::get( "freerun_restart" ))
	{
		level clientfield::set( "freerun_restart", 0 );
	}
	else
	{
		level clientfield::set( "freerun_restart", 1 );
	}	

	level.FRGame.activeTrackIndex = trackIndex;
	level.FRGame.activeTrack = level.FRGame.tracks[trackIndex];
	level.FRGame.activeSpawnPoint = level.FRGame.activeTrack.playerStart;
	level.FRGame.activeSpawnLocation = level.FRGame.activeTrack.playerStart.origin;
	level.FRGame.activeTrack.goalTrigger thread watchGoalTrigger();

	level.FRGame.faults = 0;
	level.FRGame.userSpawns = 0;
	level.FRGame.checkpointTimes = [];

	self SetLuiMenuData( level.FRGame.HUDMenu, "numFaults", level.FRGame.faults );
	self SetLuiMenuData( level.FRGame.HUDMenu, "numRetries", level.FRGame.userSpawns );

	self FreerunActivateTrack();
	
	self updateHighScores();

	self SetOrigin( level.FRGame.activeTrack.playerStart.origin );
	self SetPlayerAngles( level.FRGame.activeTrack.playerStart.angles );

	level.FRGame.activeTrack.startTrigger thread watchStartRun( self );
}

function startRun() // self == player
{
	self FreerunStartRun();

	level.FRGame.trackStartTime = GetTime();
	self thread watchUserRespawn();
}

function setupCheckpointTriggers() // self == player
{
	for ( i = 0; i < level.FRGame.checkpointTriggers.size; i++ )
	{
		level.FRGame.checkpointTriggers[i] thread util::trigger_thread( self, &onCheckpointTrigger, &leaveCheckpointTrigger );
	}
}

function onCheckpointTrigger( player, endOnString ) // self == trigger
{
	self endon( endOnString );

	level.FRGame.activeSpawnLocation = getGroundPointForOrigin( player.origin );
	level.FRGame.activeSpawnPoint = self;
}

function leaveCheckpointTrigger( player ) // self == trigger
{
	self thread watchCheckpointTrigger();
}

function watchCheckpointTrigger() // self == checkpoint trigger 
{
	self waittill( "trigger", player );

	if ( IsPlayer( player ))
	{
		if ( level.FRGame.activeSpawnPoint != self )
		{
			checkpoint_index = level.FRGame.checkpointTimes.size;

			level.FRGame.checkpointTimes[ checkpoint_index ] = GetTime() - level.FRGame.trackStartTime;

			if ( IsDefined( level.FRGame.activeTrack.highScores[0] ))
			{
				if ( IsDefined( level.FRGame.activeTrack.highScores[0].checkpointTimes[checkpoint_index] ))
				{
					delta_time = level.FRGame.checkpointTimes[ checkpoint_index ] - level.FRGame.activeTrack.highScores[0].checkpointTimes[checkpoint_index];

					if ( delta_time < 0 )
					{
						delta_time_str = "-" + delta_time + " ms";
					}
					else
					{
						delta_time_str = "+" + delta_time + " ms";
					}

					player FreerunCheckpoint( delta_time );
				}
				else
				{
					/#println( "ERROR: Freerun checkpoint out of order, missing checkpoints in high score entry!" );#/
				}
			}

			IPrintLn( "Checkpoint!" );
			playsoundatposition ("evt_checkpoint", (0,0,0));
			
		}
		self thread util::trigger_thread( player, &onCheckpointTrigger, &leaveCheckpointTrigger );
	}
}

function watchDeathTrigger() // self == death trigger 
{
	while( true )
	{
		self waittill( "trigger", player );

		if ( IsPlayer( player ))
		{
			player fallDeath();
		}
	}
}

function watchGoalTrigger() // self == goal trigger
{
	level notify( "watch_goal_trigger" );
	level endon( "watch_goal_trigger" );	

	self waittill( "trigger", player );

	if ( IsPlayer( player ))
	{
		active_track = level.FRGame.activeTrack;
		run_data = SpawnStruct();

		run_data.finishTime = GetTime() - level.FRGame.trackStartTime;
		run_data.checkpointTimes = level.FRGame.checkpointTimes;
		
		push_score = true;
		new_record = false;

		if ( active_track.highScores.size > 0 )
		{
			for ( i = 0; i < active_track.highScores.size; i++ )
			{
				if ( run_data.finishTime < active_track.highScores[i].finishTime )
				{
					push_score = false;

					ArrayInsert( active_track.highScores, run_data, i );

					if ( i == 0 )
					{
						new_record = true;
					}

					break;
				}
			}
		}
		else
		{
			new_record = true;
		}

		if ( push_score )
		{
			ArrayInsert( active_track.highScores, run_data, active_track.highScores.size );
		}

		if ( new_record )
		{
			level thread popups::DisplayTeamMessageToAll( &"OBJECTIVES_FR_NEW_RECORD", player );

			if ( level.FRGame.activeTrackIndex == 0 )
			{
				player setDStat( "freerunTrackTimes", "bestTimeA", run_data.finishTime );
			}
			else if ( level.FRGame.activeTrackIndex == 1 )
			{
				player setDStat( "freerunTrackTimes", "bestTimeB", run_data.finishTime );
			}
			else
			{
				player setDStat( "freerunTrackTimes", "bestTimeC", run_data.finishTime );
			}
		
		}

		player updateHighScores();
		player FreerunFinishRun( run_data.finishTime );

		/#DumpHighScores();#/
	}
}

/#
function DumpHighScores()
{
	for ( i = 0; i < level.FRGame.activeTrack.highScores.size; i++ )
	{
		println( ( i + 1 ) + ": " + level.FRGame.activeTrack.highScores[i].finishTime );

		for ( j = 0; j < level.FRGame.activeTrack.highScores[i].checkpointTimes.size; j++ )
		{
			println( "CP" + j + ": " + level.FRGame.activeTrack.highScores[i].checkpointTimes[ j ] );
		}
	}
}
#/

function fallDeath() // self == player
{
	// do the fall deaths increase time in trials?
	level.FRGame.faults++;
	self SetLuiMenuData( level.FRGame.HUDMenu, "numFaults", level.FRGame.faults );
	self respawnAtActiveCheckpoint();
}

function watchTrackSwitch() // self == player
{
	while( true )
	{
		wait .05;

		switch_track = false;
		if ( self ButtonPressed( "DPAD_RIGHT" ))
		{
			switch_track = true;
			curr_track_index = level.FRGame.activeTrackIndex;
			curr_track_index++;
		}
		else if ( self ButtonPressed( "DPAD_LEFT" ))
		{
			switch_track = true;
			curr_track_index = level.FRGame.activeTrackIndex;
			curr_track_index--;
		}
		else if ( self ButtonPressed( "DPAD_UP" ))
		{
			switch_track = true;
			curr_track_index = level.FRGame.activeTrackIndex;
		}

		if ( switch_track )
		{
			if ( curr_track_index == 3 )
			{
				curr_track_index = 0;
			}
			else if ( curr_track_index < 0 )
			{
				curr_track_index = 3 - 1;
			}

			activateTrack( curr_track_index );

			while ( true )
			{
				wait .05;

				if (!( self ButtonPressed( "DPAD_RIGHT" ) || self ButtonPressed( "DPAD_LEFT" ) || self ButtonPressed( "DPAD_UP" )))
				{
					break;
				}
			}
		}
	}
}

function watchUserRespawn() // self == player
{
	level endon( "activate_track" );

	while( true )
	{
		wait .05;

		if ( self ButtonPressed( "DPAD_DOWN" ))
		{
			level.FRGame.userSpawns++;
			self SetLuiMenuData( level.FRGame.HUDMenu, "numRetries", level.FRGame.userSpawns );
			self respawnAtActiveCheckpoint();
			
			while ( true )
			{
				wait .05;

				if (!( self ButtonPressed( "DPAD_DOWN" )))
				{
					break;
				}
			}
		}
	}
}

function getGroundPointForOrigin( position )
{
	trace = BulletTrace( position + (0,0,10), position - (0,0,1000), false, undefined );
	return trace["position"];
}

function watchStartRun( player ) // self == start trigger
{
	level endon( "activate_track" );

	self waittill( "trigger", trigger_ent );

	if ( trigger_ent == player )
	{
		player startRun();
	}
}

function respawnAtActiveCheckpoint() // self == player
{
	ResetGlass();

	if ( IsDefined( level.FRGame.activeSpawnPoint.spawnPoint ))
	{
		self SetOrigin( level.FRGame.activeSpawnPoint.spawnPoint.origin );
		self SetPlayerAngles( level.FRGame.activeSpawnPoint.spawnPoint.angles );
	}
	else
	{
		// no spawn point for the track start triggers
		spawn_origin = level.FRGame.activeSpawnLocation;
		spawn_origin += ( 0,0, 5.0 );	

		self SetOrigin( spawn_origin );
	}	
}

function giveCustomLoadout()
{
	self TakeAllWeapons();
	self clearPerks();
	
	self SetPerk( "specialty_fallheight" );

	self GiveWeapon( level.weaponBaseMeleeHeld );
	self setSpawnWeapon( level.weaponBaseMeleeHeld );
	
	return level.weaponBaseMeleeHeld;
}

function getBestTimeStatForTrack( trackIndex ) // self == player
{
	if ( trackIndex == 0 )
	{
		return self getDStat( "freerunTrackTimes", "bestTimeA" );
	}
	else if ( trackIndex == 1 )
	{
		return self getDStat( "freerunTrackTimes", "bestTimeB" );
	}
	else if ( trackIndex == 2 )
	{
		return self getDStat( "freerunTrackTimes", "bestTimeC" );
	}

	return 0;
}

// ================= ALL LEGACY DM STUFF BELOW

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
