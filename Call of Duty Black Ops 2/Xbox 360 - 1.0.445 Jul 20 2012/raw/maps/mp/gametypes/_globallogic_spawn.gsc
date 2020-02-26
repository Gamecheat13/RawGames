#include common_scripts\utility;
#include maps\mp\_utility;

TimeUntilSpawn( includeTeamkillDelay )
{
	if ( level.inGracePeriod && !self.hasSpawned )
		return 0;
	
	respawnDelay = 0;
	if ( self.hasSpawned )
	{
		result = self [[level.onRespawnDelay]]();
		if ( isDefined( result ) )
			respawnDelay = result;
		else
			respawnDelay = level.playerRespawnDelay;
			
		if ( includeTeamkillDelay && is_true( self.teamKillPunish ) )
			respawnDelay += maps\mp\gametypes\_globallogic_player::TeamKillDelay();
	}

	waveBased = (level.waveRespawnDelay > 0);

	if ( waveBased )
		return self TimeUntilWaveSpawn( respawnDelay );
	
	return respawnDelay;
}

allTeamsHaveExisted()
{
	foreach( team in level.teams )
	{
		if ( !level.everExisted[ team ] )
			return false;
	}
	
	return true;
}

maySpawn()
{
	if ( isDefined( level.maySpawn ) && !( self [[level.maySpawn]]() ) )
	{
		return false;
	}
	
	if ( level.inOvertime )
		return false;

	if ( level.playerQueuedRespawn && !isdefined(self.allowQueueSpawn) && !level.inGracePeriod && !level.useStartSpawns )
		return false;

	if ( level.numLives )
	{
		if ( level.teamBased )
			gameHasStarted = ( allTeamsHaveExisted() );
		else
			gameHasStarted = (level.maxPlayerCount > 1) || ( !isOneRound() && !isFirstRound() );

		if ( !self.pers["lives"] && gameHasStarted )
		{
			return false;
		}
		else if ( gameHasStarted )
		{
			// disallow spawning for late comers
			if ( !level.inGracePeriod && !self.hasSpawned && !level.wagerMatch )
				return false;
		}
	}
	return true;
}

TimeUntilWaveSpawn( minimumWait )
{
	// the time we'll spawn if we only wait the minimum wait.
	earliestSpawnTime = gettime() + minimumWait * 1000;
	
	lastWaveTime = level.lastWave[self.pers["team"]];
	waveDelay = level.waveDelay[self.pers["team"]] * 1000;
	
	if( waveDelay == 0 )
		return 0;
	
	// the number of waves that will have passed since the last wave happened, when the minimum wait is over.
	numWavesPassedEarliestSpawnTime = (earliestSpawnTime - lastWaveTime) / waveDelay;
	// rounded up
	numWaves = ceil( numWavesPassedEarliestSpawnTime );
	
	timeOfSpawn = lastWaveTime + numWaves * waveDelay;
	
	// avoid spawning everyone on the same frame
	if ( isdefined( self.waveSpawnIndex ) )
		timeOfSpawn += 50 * self.waveSpawnIndex;
	
	return (timeOfSpawn - gettime()) / 1000;
}

stopPoisoningAndFlareOnSpawn()
{
	self endon("disconnect");

	self.inPoisonArea = false;
	self.inBurnArea = false;
	self.inFlareVisionArea = false;
	self.inGroundNapalm = false;
}

spawnPlayerPrediction()
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	self endon ( "game_ended" );
	self endon ( "joined_spectators");
	self endon ( "spawned");
	
	while (1)
	{
		// wait some time between predictions
		wait( 0.5 );

		//pixbeginevent("onSpawnPlayer_Prediction");
		
		if ( IsDefined( level.onSpawnPlayerUnified ) 
			&& GetDvarInt( "scr_disableunifiedspawning" ) == 0 )
		{	// this is slightly inaccurate, we should probably call the gametype specific unified spawn, however this is prevents us having to pass the arg all the way through each gametype.
			maps\mp\gametypes\_spawning::onSpawnPlayer_Unified( true );
		}
		else
		{
			self [[level.onSpawnPlayer]](true);
		}
		
		//pixendevent();
	}
}	

spawnPlayer()
{
	pixbeginevent( "spawnPlayer_preUTS" );

	//profilelog_begintiming( 3, "ship" );

	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	level notify("player_spawned");
	self notify("end_respawn");

	self setSpawnVariables();
	
	if (!self.hasSpawned)
	{
		//if this is the first spawn, kicking off a thread to start the gamplay music 
		self.underscoreChance = 70;
		self thread maps\mp\gametypes\_globallogic_audio::sndStartMusicSystem ();
	}
	
	if ( level.teamBased )
		self.sessionteam = self.team;
	else
	{
		self.sessionteam = "none";
		self.ffateam = self.team;
	}

	hadSpawned = self.hasSpawned;

	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.damagedPlayers = [];
	if ( GetDvarint( "scr_csmode" ) > 0 )
		self.maxhealth = GetDvarint( "scr_csmode" );
	else
		self.maxhealth = level.playerMaxHealth;
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
	if ( self.pers["lives"] && ( !isDefined( level.takeLivesOnDeath ) || ( level.takeLivesOnDeath == false ) ) )
	{
		self.pers["lives"]--;
		if ( self.pers["lives"] == 0 )
		{
				level notify( "player_eliminated" );
				self notify( "player_eliminated" );
		}
	}
	self.lastStand = undefined;
	self.revivingTeammate = false;
	self.burning = undefined;
	self.nextKillstreakFree = undefined;

	self.activeUAVs = 0;
	self.activeCounterUAVs = 0;
	self.activeSatellites = 0;
	
	self.disabledWeapon = 0;
	self resetUsability();

	self maps\mp\gametypes\_globallogic_player::resetAttackerList();
	
	self.diedOnVehicle= undefined;

	if ( !self.wasAliveAtMatchStart )
	{
		if ( level.inGracePeriod || maps\mp\gametypes\_globallogic_utils::getTimePassed() < 20 * 1000 )
			self.wasAliveAtMatchStart = true;
	}
	
	self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	if( level.console )	
		self setClientFOV( 65 );
	
	
	{
		pixbeginevent("onSpawnPlayer");
		if ( IsDefined( level.onSpawnPlayerUnified ) 
			&& GetDvarint( "scr_disableunifiedspawning" ) == 0 )
		{
			self [[level.onSpawnPlayerUnified]]();
		}
		else
		{
			self [[level.onSpawnPlayer]](false);
		}
		
		if ( IsDefined( level.playerSpawnedCB ) )
		{
			self [[level.playerSpawnedCB]]();
		}
		pixendevent();
	}
	
	pixendevent();// "END: spawnPlayer_preUTS" 

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	
	pixbeginevent( "spawnPlayer_postUTS" );
	
	self thread stopPoisoningAndFlareOnSpawn();

	self StopBurning();
	
	assert( maps\mp\gametypes\_globallogic_utils::isValidClass( self.class ) );
	
	if( SessionModeIsZombiesGame() )
	{
		self maps\mp\gametypes\_class::giveLoadoutLevelSpecific( self.team, self.class );
	}
	else
	{
		self maps\mp\gametypes\_class::setClass( self.class );
		self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
	}
	
	if ( level.inPrematchPeriod )
	{
		self freeze_player_controls( true );

		team = self.pers["team"];
	
//CDC New music system		
		if( isDefined( self.pers["music"].spawn ) && self.pers["music"].spawn == false )
		{
			
			if (level.wagerMatch)
			{
				music = "SPAWN_WAGER";
			}
			else 
			{
				music = game["music"]["spawn_" + team];
			}
			self thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( music, false, false );
			
			self.pers["music"].spawn = true;
		}
		
		if ( level.splitscreen )
		{
			if ( isDefined( level.playedStartingMusic ) )
				music = undefined;
			else
				level.playedStartingMusic = true;
		}

		if( !isdefined(level.disablePrematchMessages) || (level.disablePrematchMessages==false) )
		{
			thread maps\mp\gametypes\_hud_message::showInitialFactionPopup( team );
			if ( isDefined( game["dialog"]["gametype"] ) && (!level.splitscreen || self == level.players[0]) )
			{
				if( !isDefined( level.inFinalFight ) || !level.inFinalFight )
				{
					if( level.hardcoreMode )
						self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "gametype_hardcore" );
					else
						self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "gametype" );
				}
			}
		}
	}
	else
	{
		self freeze_player_controls( false );
		self enableWeapons();
		if ( !hadSpawned && game["state"] == "playing" )
		{
			pixbeginevent("sound");
			team = self.team;
			
//CDC New music system TODO add short spawn music
			if( isDefined( self.pers["music"].spawn ) && self.pers["music"].spawn == false )
			{
				self thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( "SPAWN_SHORT", false, false );
				self.pers["music"].spawn = true;
			}		
			if ( level.splitscreen )
			{
				if ( isDefined( level.playedStartingMusic ) )
					music = undefined;
				else
					level.playedStartingMusic = true;
			}
			
			if( !isdefined(level.disablePrematchMessages) || (level.disablePrematchMessages==false) )
			{
				thread maps\mp\gametypes\_hud_message::showInitialFactionPopup( team );
				if ( isDefined( game["dialog"]["gametype"] ) && (!level.splitscreen || self == level.players[0]) )
				{
					if( !isDefined( level.inFinalFight ) || !level.inFinalFight )
					{
						if( level.hardcoreMode )
							self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "gametype_hardcore" );
						else
							self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "gametype" );

						if ( team == game["attackers"] )
							self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "offense_obj", "introboost" );
						else
							self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "defense_obj", "introboost" );
					}
				}
			}
		
			pixendevent();//"sound"
		}
	}

	if ( GetDvar( "scr_showperksonspawn" ) == "" )
		SetDvar( "scr_showperksonspawn", "0" );

	// Make sure that we dont show the perks on spawn if we are in hardcore.
	if ( level.hardcoreMode ) 
		SetDvar( "scr_showperksonspawn", "0" );

	if ( !level.splitscreen && GetDvarint( "scr_showperksonspawn" ) == 1 && game["state"] != "postgame" )
	{
		pixbeginevent("showperksonspawn");
	
		//Checks to make sure perks are allowed. - Leif
		if ( level.perksEnabled == 1)
		{
			self maps\mp\gametypes\_hud_util::showPerks( );
		}
		
		self thread maps\mp\gametypes\_globallogic_ui::hideLoadoutAfterTime( 3.0 );
		self thread maps\mp\gametypes\_globallogic_ui::hideLoadoutOnDeath();
		 
		pixendevent();//"showperksonspawn"
	}
	
	if ( isDefined( self.pers["momentum"] ) )
	{
		self.momentum = self.pers["momentum"];
	}
	
	pixendevent();//"END: spawnPlayer_postUTS" 
	
	waittillframeend;
	
	self notify( "spawned_player" );

	self maps\mp\gametypes\_gametype_variants::onPlayerSpawn();

	self logstring( "S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] );

	SetDvar( "scr_selecting_location", "" );

	if ( self is_bot() )
	{
		pixbeginevent("bot");
		self thread maps\mp\bots\_bot::bot_spawn();
		pixendevent(); // "bot"
	}
	
	if( !SessionModeIsZombiesGame() )
	{
		self thread maps\mp\killstreaks\_killstreaks::killstreakWaiter();

		self thread maps\mp\_vehicles::vehicleDeathWaiter();
		self thread maps\mp\_vehicles::turretDeathWaiter();
	}
	
	/#
	if ( GetDvarint( "scr_xprate" ) > 0 )
		self thread maps\mp\gametypes\_globallogic_score::xpRateThread();
	#/
	
	
	if ( game["state"] == "postgame" )
	{
		assert( !level.intermission );
		// We're in the victory screen, but before intermission
		self maps\mp\gametypes\_globallogic_player::freezePlayerForRoundEnd();
	}
}

spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator( origin, angles );
}

// spawnSpectator clone without notifies for spawning between respawn delays
respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

// spawnSpectator helper
in_spawnSpectator( origin, angles )
{
	pixmarker("BEGIN: in_spawnSpectator");
	self setSpawnVariables();
	
	// don't clear lower message if not actually a spectator,
	// because it probably has important information like when we'll spawn
	if ( self.pers["team"] == "spectator" )
		self clearLowerMessage();
	
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	else
		self.statusicon = "hud_status_dead";

	maps\mp\gametypes\_spectating::setSpectatePermissionsForMachine();

	[[level.onSpawnSpectator]]( origin, angles );
	
	if ( level.teamBased && !level.splitscreen )
		self thread spectatorThirdPersonness();
	
	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	pixmarker("END: in_spawnSpectator");
}

spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");
	
	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");
	
	self.spectatingThirdPerson = false;
}

forceSpawn( time )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );

	if ( !isdefined( time ) )
	{
			time = 60;
	}
	
	wait ( time );

	if ( self.hasSpawned )
		return;
	
	if ( self.pers["team"] == "spectator" )
		return;
	
	if ( !maps\mp\gametypes\_globallogic_utils::isValidClass( self.pers["class"] ) )
	{
		self.pers["class"] = "CLASS_CUSTOM1";
		self.class = self.pers["class"];
	}
	
	self maps\mp\gametypes\_globallogic_ui::closeMenus();
	self thread [[level.spawnClient]]();
}


kickIfDontSpawn()
{
/#
	if( GetDvarint( "scr_hostmigrationtest" ) == 1 )
	{
		return;
	}
#/

	if ( self IsHost() )
	{
		// don't try to kick the host
		return;
	}
	
	self kickIfIDontSpawnInternal();
	// clear any client dvars here,
	// like if we set anything to change the menu appearance to warn them of kickness
}

kickIfIDontSpawnInternal()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );
	
	waittime = 90;
	if ( GetDvar( "scr_kick_time") != "" )
		waittime = GetDvarfloat( "scr_kick_time");
	mintime = 45;
	if ( GetDvar( "scr_kick_mintime") != "" )
		mintime = GetDvarfloat( "scr_kick_mintime");
	
	starttime = gettime();
	
	kickWait( waittime );
	
	timePassed = (gettime() - starttime)/1000;
	if ( timePassed < waittime - .1 && timePassed < mintime )
		return;
	
	if ( self.hasSpawned )
		return;
		
	if ( SessionModeIsPrivate() )
	{
		return;
	}
		
	if ( self.pers["team"] == "spectator" )
		return;
	
	kick( self getEntityNumber() );
}

kickWait( waittime )
{
	level endon("game_ended");
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( waittime );
}

spawnInterRoundIntermission()
{
	self notify("spawned");
	self notify("end_respawn");
	
	self setSpawnVariables();
	
	self clearLowerMessage();
	
	self freeze_player_controls( false );

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	
	self maps\mp\gametypes\_globallogic_defaults::default_onSpawnIntermission();
	self SetOrigin( self.origin );
	self SetPlayerAngles( self.angles );
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}

spawnIntermission( useDefaultCallback )
{
	self notify("spawned");
	self notify("end_respawn");
	self endon("disconnect");
	
	self setSpawnVariables();
	
	self clearLowerMessage();
	
	self freeze_player_controls( false );
	
 	if ( level.rankedmatch && wasLastRound() )
 	{
 	 	self maps\mp\_popups::displayEndGamePopUps();
		if (( self.postGameMilestones || self.postGameContracts || self.postGamePromotion ) )
		{
			if ( self.postGamePromotion )
				self playLocalSound( "mus_level_up" );
			else if ( self.postGameContracts )
				self playLocalSound( "mus_challenge_complete" );
			else if ( self.postGameMilestones )
				self playLocalSound( "mus_contract_complete" );

			self clearPopups();
			self closeInGameMenu();	
	
			self openMenu( game["menu_endgameupdate"] );
	
			waitTime = 4.0;
			while ( waitTime )
			{
				wait ( 0.25 );
				waitTime -= 0.25;
	
				self openMenu( game["menu_endgameupdate"] );
			}
			
			self closeMenu();
		}
	}

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	
	if ( IsDefined( useDefaultCallback ) && useDefaultCallback )
		maps\mp\gametypes\_globallogic_defaults::default_onSpawnIntermission();
	else
		[[level.onSpawnIntermission]]();
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}

spawnQueuedClientOnTeam( team )
{
	player_to_spawn = undefined;
		
	// find the first dead player who is not already waiting to spawn
	for (i = 0; i < level.deadPlayers[team].size; i++)
	{
		player = level.deadPlayers[team][i];
		
		if ( player.waitingToSpawn )
			continue;

		player_to_spawn = player;
		break;
	}

	if ( isdefined(player_to_spawn) )
	{
		player_to_spawn.allowQueueSpawn = true;
		
		player_to_spawn maps\mp\gametypes\_globallogic_ui::closeMenus();
		player_to_spawn thread [[level.spawnClient]]();
	}	
}

spawnQueuedClient( dead_player_team, killer )
{
	if ( !level.playerQueuedRespawn )
		return;
		
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	spawn_team = undefined;

	if ( isdefined( killer ) && isdefined( killer.team ) && isdefined( level.teams[ killer.team ] ) )
		spawn_team = killer.team;

	if ( isdefined( spawn_team ) )
	{
		spawnQueuedClientOnTeam( spawn_team );
		return;
	}
	
	// we could not determine the killer team so spawn a player from each team
	// there may be ways to exploit this by killing someone and the switching to spectator
	foreach( team in level.teams )
	{
		if ( team == dead_player_team )
			continue;
			
		spawnQueuedClientOnTeam( team );
	}
}

allTeamsNearScoreLimit()
{
	if ( !level.teambased )
		return false;
		
	if ( level.scoreLimit <= 1 )
		return false;
		
	foreach( team in level.teams )
	{
		if ( !(game["teamScores"][team] >= level.scoreLimit - 1) )
			return false;
	}
	
	return true;
}

shouldShowRespawnMessage()
{
	if ( wasLastRound() )
		return false;
		
	if ( isOneRound() )
		return false;
		
	if ( ( isDefined( level.livesDoNotReset ) && level.livesDoNotReset ) )
		return false;
	
	if ( allTeamsNearScoreLimit() )
		return false;
	
	return true;
}

default_spawnMessage()
{
	setLowerMessage( game["strings"]["spawn_next_round"] );
	self thread maps\mp\gametypes\_globallogic_ui::removeSpawnMessageShortly( 3 );
}

showSpawnMessage()
{
	if ( shouldShowRespawnMessage() )
	{
		self thread [[level.spawnMessage]]();
	}
}

spawnClient( timeAlreadyPassed )
{
	pixbeginevent("spawnClient");
	assert(	isDefined( self.team ) );
	assert(	maps\mp\gametypes\_globallogic_utils::isValidClass( self.class ) );
	
	if ( !self maySpawn() )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;
		
		self showSpawnMessage();
			
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		pixendevent();
		return;
	}
	
	if ( self.waitingToSpawn )
	{
		pixendevent();
		return;
	}
	self.waitingToSpawn = true;
	self.allowQueueSpawn = undefined;
	
	self waitAndSpawnClient( timeAlreadyPassed );
	
	if ( isdefined( self ) )
		self.waitingToSpawn = false;
	
	pixendevent();
}

waitAndSpawnClient( timeAlreadyPassed )
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	level endon ( "game_ended" );

	if ( !isdefined( timeAlreadyPassed ) )
		timeAlreadyPassed = 0;
	
	spawnedAsSpectator = false;

	if ( is_true( self.teamKillPunish ) )
	{
		teamKillDelay = maps\mp\gametypes\_globallogic_player::TeamKillDelay();
		if ( teamKillDelay > timeAlreadyPassed )
		{
			teamKillDelay -= timeAlreadyPassed;
			timeAlreadyPassed = 0;
		}
		else
		{
			timeAlreadyPassed -= teamKillDelay;
			teamKillDelay = 0;
		}
		
		if ( teamKillDelay > 0 )
		{
			setLowerMessage( &"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay );
			
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
			spawnedAsSpectator = true;
			
			wait( teamKillDelay );
		}
		
		self.teamKillPunish = false;
	}
	
	if ( !isdefined( self.waveSpawnIndex ) && isdefined( level.wavePlayerSpawnIndex[self.team] ) )
	{
		self.waveSpawnIndex = level.wavePlayerSpawnIndex[self.team];
		level.wavePlayerSpawnIndex[self.team]++;
	}
	
	timeUntilSpawn = TimeUntilSpawn( false );
	if ( timeUntilSpawn > timeAlreadyPassed )
	{
		timeUntilSpawn -= timeAlreadyPassed;
		timeAlreadyPassed = 0;
	}
	else
	{
		timeAlreadyPassed -= timeUntilSpawn;
		timeUntilSpawn = 0;
	}
	
	if ( timeUntilSpawn > 0 )
	{
		// spawn player into spectator on death during respawn delay, if he switches teams during this time, he will respawn next round
		if ( level.playerQueuedRespawn )
			setLowerMessage( game["strings"]["you_will_spawn"], timeUntilSpawn );
		else if ( self IsSplitscreen() )
			setLowerMessage( game["strings"]["waiting_to_spawn_ss"], timeUntilSpawn, true );
		else
			setLowerMessage( game["strings"]["waiting_to_spawn"], timeUntilSpawn );
		
		if ( !spawnedAsSpectator )
		{
			spawnOrigin = self.origin + (0, 0, 60);
			spawnAngles = self.angles;
			if ( isdefined ( level.useIntermissionPointsOnWaveSpawn ) && [[level.useIntermissionPointsOnWaveSpawn]]() == true ) 
			{
	    		spawnPoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	    		if ( isdefined( spawnPoint ) )
				{
		    		spawnOrigin = spawnPoint.origin;
					spawnAngles = spawnPoint.angles;
				}
			}
			
			self thread	respawn_asSpectator( spawnOrigin, spawnAngles );
		}
		spawnedAsSpectator = true;
		
		self maps\mp\gametypes\_globallogic_utils::waitForTimeOrNotify( timeUntilSpawn, "force_spawn" );
		
		self notify("stop_wait_safe_spawn_button");
	}
	
	waveBased = (level.waveRespawnDelay > 0);
	if ( !level.playerForceRespawn && self.hasSpawned && !waveBased && !self.wantSafeSpawn && !level.playerQueuedRespawn )
	{
		setLowerMessage( game["strings"]["press_to_spawn"] );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitRespawnOrSafeSpawnButton();
	}
	

	self.waitingToSpawn = false;
	
	self clearLowerMessage();
	
	self.waveSpawnIndex = undefined;
	self.respawnTimerStartTime = undefined;
	
	self thread	[[level.spawnPlayer]]();
}

waitRespawnOrSafeSpawnButton()
{
	self endon("disconnect");
	self endon("end_respawn");

	while (1)
	{
		if ( self useButtonPressed() )
			break;

		wait .05;
	}
}

waitInSpawnQueue( )
{
	self endon("disconnect");
	self endon("end_respawn");
	
	if ( !level.inGracePeriod && !level.useStartSpawns )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;

		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);

		self waittill("queue_respawn" );
	}
}

setThirdPerson( value )
{
	if( !level.console )	
		return;

	if ( !IsDefined( self.spectatingThirdPerson ) || value != self.spectatingThirdPerson )
	{
		self.spectatingThirdPerson = value;
		if ( value )
		{
			self SetClientThirdPerson( 1 );
			self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
			self SetClientFOV( 40 );
		}
		else
		{
			self SetClientThirdPerson( 0 );
			self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
			self SetClientFOV( 65 );
		}
	}
}


setSpawnVariables()
{
	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );
}
