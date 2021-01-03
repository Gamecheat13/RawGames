#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\bots\_bot;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\_teamops;

#namespace globallogic_spawn;

#precache( "eventstring", "player_spawned" );
#precache( "eventstring", "show_gametype_objective_hint" );

function TimeUntilSpawn( includeTeamkillDelay )
{
	if ( level.inGracePeriod && !self.hasSpawned )
		return 0;
	
	respawnDelay = 0;
	if ( self.hasSpawned )
	{
		result = self [[level.onRespawnDelay]]();
		if ( isdefined( result ) )
			respawnDelay = result;
		else
			respawnDelay = level.playerRespawnDelay;
			
		if ( self.suicide && level.suicideSpawnDelay > 0 )
		{
			respawnDelay += level.suicideSpawnDelay;
		}
		
		if ( self.teamKilled && level.teamKilledSpawnDelay > 0 )
		{
			respawnDelay += level.teamKilledSpawnDelay;
		}
		
		if ( includeTeamkillDelay && ( isdefined( self.teamKillPunish ) && self.teamKillPunish ) )
			respawnDelay += globallogic_player::TeamKillDelay();
	}

	waveBased = (level.waveRespawnDelay > 0);

	if ( waveBased )
		return self TimeUntilWaveSpawn( respawnDelay );
	
	//Spawn straight away if player used resurrect ability
	if ( ( isdefined( self.usedResurrect ) && self.usedResurrect ) )
	{		
		return 0;
	}
		
	return respawnDelay;
}

function allTeamsHaveExisted()
{
	foreach( team in level.teams )
	{
		if ( !level.everExisted[ team ] )
			return false;
	}
	
	return true;
}

function maySpawn()
{
	if ( isdefined( level.maySpawn ) && !( self [[level.maySpawn]]() ) )
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
			gameHasStarted = (level.maxPlayerCount > 1) || ( !util::isOneRound() && !util::isFirstRound() );
		
		if ( !self.pers["lives"] )
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

function TimeUntilWaveSpawn( minimumWait )
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

function stopPoisoningAndFlareOnSpawn()
{
	self endon("disconnect");

	self.inPoisonArea = false;
	self.inBurnArea = false;
	self.inFlareVisionArea = false;
	self.inGroundNapalm = false;
}

function spawnPlayerPrediction()
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
		
		if ( isdefined( level.onSpawnPlayerUnified ) 
			&& GetDvarInt( "scr_disableunifiedspawning" ) == 0 )
		{	// this is slightly inaccurate, we should probably call the gametype specific unified spawn, however this is prevents us having to pass the arg all the way through each gametype.
			spawning::onSpawnPlayer_Unified( true );
		}
		else
		{
			self [[level.onSpawnPlayer]](true);
		}
		
		//pixendevent();
	}
}

function doInitialSpawnMessaging()
{
	self endon("disconnect" );
	
	if( isdefined( level.disablePrematchMessages ) && level.disablePrematchMessages )
	{
		return;
	}
	
	team = self.pers["team"];
	thread hud_message::showInitialFactionPopup( team );
	
	if ( isdefined( level.leaderDialog ) && (!level.splitscreen || self == level.players[0]) )
	{
		if( !isdefined( level.inFinalFight ) || !level.inFinalFight )
		{
			if( level.hardcoreMode )
				self globallogic_audio::leader_dialog_on_player( level.leaderDialog.startHcGameDialogIndex );
			else
				self globallogic_audio::leader_dialog_on_player( level.leaderDialog.startGameDialogIndex );
		}
	}
	
	while ( level.inPrematchPeriod )
	{
		{wait(.05);};
	}
	
	hintMessage = util::getObjectiveHintText( team );
	if ( isdefined( hintMessage ) )
	{
		self LUINotifyEvent( &"show_gametype_objective_hint", 1, hintMessage );
	}
	
	if ( isdefined( level.leaderDialog ) )
    {
		if ( team == game["attackers"] )
			self globallogic_audio::leader_dialog_on_player( level.leaderDialog.offenseOrderDialogIndex, "introboost" );
		else
			self globallogic_audio::leader_dialog_on_player( level.leaderDialog.defenseOrderDialogIndex, "introboost" );
    }
}

function spawnPlayer()
{
	pixbeginevent( "spawnPlayer_preUTS" );

	//profilelog_begintiming( 3, "ship" );

	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	level notify("player_spawned");
	self notify("end_respawn");

	self setSpawnVariables();
	self LUINotifyEvent( &"player_spawned", 0 );

	resetMomentum = false;	
	if ( !isdefined( self.pers["resetMomentumOnSpawn"] ) || self.pers["resetMomentumOnSpawn"] )
	{
		self globallogic_score::resetPlayerMomentumOnSpawn();
		self.pers["resetMomentumOnSpawn"] = false;
		resetMomentum = true;
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
	if ( self.pers["lives"] && ( !isdefined( level.takeLivesOnDeath ) || ( level.takeLivesOnDeath == false ) ) )
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

	self.deathMachineKills = 0;
	
	self.disabledWeapon = 0;
	self util::resetUsability();

	self globallogic_player::resetAttackerList();
	
	self.diedOnVehicle= undefined;

	if ( !self.wasAliveAtMatchStart )
	{
		if ( level.inGracePeriod || globallogic_utils::getTimePassed() < 20 * 1000 )
			self.wasAliveAtMatchStart = true;
	}
	
	self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	self resetFov();
	
	
	{
		pixbeginevent("onSpawnPlayer");
		if ( isdefined( level.onSpawnPlayerUnified ) 
			&& GetDvarint( "scr_disableunifiedspawning" ) == 0 )
		{
			self [[level.onSpawnPlayerUnified]]();
			if( isdefined( game["teamops"].teamopsName ) )
			{
				teamops = game["teamops"].data[game["teamops"].teamopsName];
				TeamOpsStart( game["teamops"].teamOpsID, game["teamops"].teamopsRewardIndex, game["teamops"].teamopsStartTime, teamops.time );
				teamops::updateTeamOps( undefined, undefined, self.team );
			}
		}
		else
		{
			self [[level.onSpawnPlayer]](false);
		}
		
		if ( isdefined( level.playerSpawnedCB ) )
		{
			self [[level.playerSpawnedCB]]();
		}
		pixendevent();
	}
	
	pixendevent();// "END: spawnPlayer_preUTS" 

	level thread globallogic::updateTeamStatus();
	
	pixbeginevent( "spawnPlayer_postUTS" );
	
	self thread stopPoisoningAndFlareOnSpawn();

	self.sensorGrenadeData = undefined;

	assert( globallogic_utils::isValidClass( self.curClass ) );
	
	if( SessionModeIsZombiesGame() )
	{
		self loadout::giveLoadoutLevelSpecific( self.team, self.curClass );
	}
	else
	{
		self loadout::setClass( self.curClass );
		self loadout::giveLoadout( self.team, self.curClass );
	}
	
	if ( level.inPrematchPeriod )
	{
		self util::freeze_player_controls( true );

		team = self.pers["team"];
	
//CDC New music system		
		if( isdefined( self.pers["music"].spawn ) && self.pers["music"].spawn == false )
		{
			
			if (level.wagerMatch)
			{
				music = "SPAWN_WAGER";
			}
			else 
			{
				music = game["music"]["spawn_" + team];
			}
			
			if( game[ "roundsplayed" ] == 0 )
			{
				self thread sndDelayedMusicStart("spawnFull");
			}
			else
			{
				self thread sndDelayedMusicStart("spawnShort");
			}
			
			self.pers["music"].spawn = true;
		}
		
		if ( level.splitscreen )
		{
			if ( isdefined( level.playedStartingMusic ) )
				music = undefined;
			else
				level.playedStartingMusic = true;
		}

		self thread doInitialSpawnMessaging();
	}
	else
	{
		self util::freeze_player_controls( false );
		self enableWeapons();
		if ( !hadSpawned && game["state"] == "playing" )
		{
			pixbeginevent("sound");
			team = self.team;
			
//CDC New music system TODO add short spawn music
			if( isdefined( self.pers["music"].spawn ) && self.pers["music"].spawn == false )
			{
				music = game["music"]["spawn_" + team];
				
				self thread sndDelayedMusicStart( "spawnShort" );
				
				self.pers["music"].spawn = true;
			}		
			if ( level.splitscreen )
			{
				if ( isdefined( level.playedStartingMusic ) )
					music = undefined;
				else
					level.playedStartingMusic = true;
			}
			
			self thread doInitialSpawnMessaging();
		
			pixendevent();//"sound"
		}
	}

	if ( GetDvarString( "scr_showperksonspawn" ) == "" )
		SetDvar( "scr_showperksonspawn", "0" );

	// Make sure that we dont show the perks on spawn if we are in hardcore.
	if ( level.hardcoreMode ) 
		SetDvar( "scr_showperksonspawn", "0" );

	if ( GetDvarint( "scr_showperksonspawn" ) == 1 && game["state"] != "postgame" )
	{
		pixbeginevent("showperksonspawn");
	
		//Checks to make sure perks are allowed. - Leif
		if ( level.perksEnabled == 1)
		{
			self hud::showPerks( );
		}
		
		pixendevent();//"showperksonspawn"
	}
	
	if ( self HasPerk( "specialty_anteup" ) && resetMomentum ) 
	{ 
		start = GetDvarInt( "perk_killstreakAnteUpResetValue" ); 
		globallogic_score::_setPlayerMomentum( self, start, false );
	}	
	
	if ( isdefined( self.pers["momentum"] ) )
	{
		self.momentum = self.pers["momentum"];
	}
	
	pixendevent();//"END: spawnPlayer_postUTS" 
	
	waittillframeend;
	
	self notify( "spawned_player" );
	callback::callback( #"on_player_spawned" );

	/#print( "S " + self.origin[0] + " " + self.origin[1] + " " + self.origin[2] + "\n" );#/

	SetDvar( "scr_selecting_location", "" );

	if ( self util::is_bot() )
	{
		pixbeginevent("bot");
		self thread bot::bot_spawn();
		pixendevent(); // "bot"
	}
	
	if( !SessionModeIsZombiesGame() )
	{
		self thread killstreaks::killstreak_waiter();
	}
	
	/#
	if ( GetDvarint( "scr_xprate" ) > 0 )
		self thread globallogic_score::xpRateThread();
	#/
	
	
	if ( game["state"] == "postgame" )
	{
		assert( !level.intermission );
		// We're in the victory screen, but before intermission
		self globallogic_player::freezePlayerForRoundEnd();
	}
	
	self util::set_lighting_state();
}
function sndDelayedMusicStart(music)
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	while(level.inPrematchPeriod)
	{
		wait(.05);
	}
	
	self thread globallogic_audio::set_music_on_player( music );
}

function spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator( origin, angles );
}

// spawnSpectator clone without notifies for spawning between respawn delays
function respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

// spawnSpectator helper
function in_spawnSpectator( origin, angles )
{
	pixmarker("BEGIN: in_spawnSpectator");
	self setSpawnVariables();
	
	// don't clear lower message if not actually a spectator,
	// because it probably has important information like when we'll spawn
	if ( self.pers["team"] == "spectator" )
		self util::clearLowerMessage();
	
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

	spectating::set_permissions_for_machine();

	[[level.onSpawnSpectator]]( origin, angles );
	
	if ( level.teamBased && !level.splitscreen )
		self thread spectatorThirdPersonness();
	
	level thread globallogic::updateTeamStatus();
	pixmarker("END: in_spawnSpectator");
}

function spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");
	
	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");
	
	self.spectatingThirdPerson = false;
}

function forceSpawn( time )
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
	
	if ( !globallogic_utils::isValidClass( self.pers["class"] ) )
	{
		self.pers["class"] = "CLASS_CUSTOM1";
		self.curClass = self.pers["class"];
	}
	
	self globallogic_ui::closeMenus();
	self thread [[level.spawnClient]]();
}


function kickIfDontSpawn()
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

function kickIfIDontSpawnInternal()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );
	
	waittime = 90;
	if ( GetDvarString( "scr_kick_time") != "" )
		waittime = GetDvarfloat( "scr_kick_time");
	mintime = 45;
	if ( GetDvarString( "scr_kick_mintime") != "" )
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
	
	if ( !maySpawn() )
		return;
		
	globallogic::gameHistoryPlayerKicked();
	
	kick( self getEntityNumber() );
}

function kickWait( waittime )
{
	level endon("game_ended");
	hostmigration::waitLongDurationWithHostMigrationPause( waittime );
}

function spawnInterRoundIntermission()
{
	self notify("spawned");
	self notify("end_respawn");
	
	self setSpawnVariables();
	
	self util::clearLowerMessage();
	
	self util::freeze_player_controls( false );

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	
	self globallogic_defaults::default_onSpawnIntermission();
	self SetOrigin( self.origin );
	self SetPlayerAngles( self.angles );
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}

function spawnIntermission( useDefaultCallback, endGame )
{
	self notify("spawned");
	self notify("end_respawn");
	self endon("disconnect");
	
	self setSpawnVariables();
	
	self util::clearLowerMessage();
	
	self util::freeze_player_controls( false );

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	
	if ( isdefined( useDefaultCallback ) && useDefaultCallback )
		globallogic_defaults::default_onSpawnIntermission();
	else
		[[level.onSpawnIntermission]]( endGame );
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}

function spawnQueuedClientOnTeam( team )
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
		
		player_to_spawn globallogic_ui::closeMenus();
		player_to_spawn thread [[level.spawnClient]]();
	}	
}

function spawnQueuedClient( dead_player_team, killer )
{
	if ( !level.playerQueuedRespawn )
		return;
		
	util::WaitTillSlowProcessAllowed();

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

function allTeamsNearScoreLimit()
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

function shouldShowRespawnMessage()
{
	if ( util::wasLastRound() )
		return false;
		
	if ( util::isOneRound() )
		return false;
		
	if ( ( isdefined( level.livesDoNotReset ) && level.livesDoNotReset ) )
		return false;
	
	if ( allTeamsNearScoreLimit() )
		return false;
	
	return true;
}

function default_spawnMessage()
{
	util::setLowerMessage( game["strings"]["spawn_next_round"] );
	self thread globallogic_ui::removeSpawnMessageShortly( 3 );
}

function showSpawnMessage()
{
	if ( shouldShowRespawnMessage() )
	{
		self thread [[level.spawnMessage]]();
	}
}

function spawnClient( timeAlreadyPassed )
{
	pixbeginevent("spawnClient");
	assert(	isdefined( self.team ) );
	assert(	globallogic_utils::isValidClass( self.curClass ) );
	
	if ( !self maySpawn() && !( isdefined( self.usedResurrect ) && self.usedResurrect ) )
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

function waitAndSpawnClient( timeAlreadyPassed )
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	level endon ( "game_ended" );

	if ( !isdefined( timeAlreadyPassed ) )
		timeAlreadyPassed = 0;
	
	spawnedAsSpectator = false;

	if ( ( isdefined( self.teamKillPunish ) && self.teamKillPunish ) )
	{
		teamKillDelay = globallogic_player::TeamKillDelay();
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
			util::setLowerMessage( &"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay );
			
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
			util::setLowerMessage( game["strings"]["you_will_spawn"], timeUntilSpawn );
		else if ( self IsSplitscreen() )
			util::setLowerMessage( game["strings"]["waiting_to_spawn_ss"], timeUntilSpawn, true );
		else
			util::setLowerMessage( game["strings"]["waiting_to_spawn"], timeUntilSpawn );
		
		if ( !spawnedAsSpectator )
		{
			spawnOrigin = self.origin + (0, 0, 60);
			spawnAngles = self.angles;
			if ( isdefined ( level.useIntermissionPointsOnWaveSpawn ) && [[level.useIntermissionPointsOnWaveSpawn]]() == true ) 
			{
	    		spawnPoint = spawnlogic::get_random_intermission_point();
	    		if ( isdefined( spawnPoint ) )
				{
		    		spawnOrigin = spawnPoint.origin;
					spawnAngles = spawnPoint.angles;
				}
			}
			
			self thread	respawn_asSpectator( spawnOrigin, spawnAngles );
		}
		spawnedAsSpectator = true;
		
		self globallogic_utils::waitForTimeOrNotify( timeUntilSpawn, "force_spawn" );
		
		self notify("stop_wait_safe_spawn_button");
	}
	
	if ( isdefined( level.gametypeSpawnWaiter ) )
	{
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		if ( !self [[level.gametypeSpawnWaiter]]() )
		{
			self.waitingToSpawn = false;
	
			self util::clearLowerMessage();
			
			self.waveSpawnIndex = undefined;
			self.respawnTimerStartTime = undefined;
			
			return;
		}
	}
	
	waveBased = (level.waveRespawnDelay > 0);
	if ( !level.playerForceRespawn && self.hasSpawned && !waveBased && !self.wantSafeSpawn && !level.playerQueuedRespawn )
	{
		util::setLowerMessage( game["strings"]["press_to_spawn"] );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitRespawnOrSafeSpawnButton();
	}

	self.waitingToSpawn = false;
	
	self util::clearLowerMessage();
	
	self.waveSpawnIndex = undefined;
	self.respawnTimerStartTime = undefined;
	
	self thread	[[level.spawnPlayer]]();
}

function waitRespawnOrSafeSpawnButton()
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

function waitInSpawnQueue( )
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

function setThirdPerson( value )
{
	if( !level.console )	
		return;

	if ( !isdefined( self.spectatingThirdPerson ) || value != self.spectatingThirdPerson )
	{
		self.spectatingThirdPerson = value;
		if ( value )
		{
			self SetClientThirdPerson( 1 );
			self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
		}
		else
		{
			self SetClientThirdPerson( 0 );
			self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
		}
		self resetFov();
	}
}


function setSpawnVariables()
{
	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );
}
