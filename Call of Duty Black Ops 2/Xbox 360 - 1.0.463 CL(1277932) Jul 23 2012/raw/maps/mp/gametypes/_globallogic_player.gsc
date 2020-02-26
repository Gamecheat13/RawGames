#include maps\mp\_utility;
#include common_scripts\utility;

freezePlayerForRoundEnd()
{
	self clearLowerMessage();
	
	self closeMenu();
	self closeInGameMenu();
	
	self freeze_player_controls( true );
	
	if( !SessionModeIsZombiesGame() )
	{
		currentWeapon = self GetCurrentWeapon();
		if ( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( currentWeapon ) && !maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon( currentWeapon ) )
			self takeWeapon( currentWeapon );
	}
//	self _disableWeapon();
}

Callback_PlayerConnect()
{
	thread notifyConnecting();

	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	
	if( IsDefined( level.reset_clientdvars ) )
		self [[level.reset_clientdvars]]();

	waittillframeend;
	self.statusicon = "";

	self.guid = self getGuid();

	profilelog_begintiming( 4, "ship" );

	level notify( "connected", self );
	
	if ( self IsHost() )
		self thread maps\mp\gametypes\_globallogic::listenForGameEnd();

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
	{
		iPrintLn(&"MP_CONNECTED", self);
	}

	if( !isdefined( self.pers["score"] ) )
	{
		self thread maps\mp\gametypes\_persistence::adjustRecentStats();
		self maps\mp\gametypes\_persistence::setAfterActionReportStat( "valid", 0 );		
		if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) && !( self IsHost() ) )
			self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerMatchFailed", 1 );
		else
			self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerMatchFailed", 0 );
	}
	
	// track match and hosting stats once per match
	if( ( level.rankedMatch || level.wagerMatch ) && !IsDefined( self.pers["matchesPlayedStatsTracked"] ) )
	{
		gameMode = maps\mp\gametypes\_globallogic::GetCurrentGameMode();
		self maps\mp\gametypes\_globallogic::IncrementMatchCompletionStat( gameMode, "played", "started" );
				
		if ( !IsDefined( self.pers["matchesHostedStatsTracked"] ) && self IsLocalToHost() )
		{
			self maps\mp\gametypes\_globallogic::IncrementMatchCompletionStat( gameMode, "hosted", "started" );
			self.pers["matchesHostedStatsTracked"] = true;
		}
		
		self.pers["matchesPlayedStatsTracked"] = true;
		self thread maps\mp\gametypes\_persistence::uploadStatsSoon();
	}

	self maps\mp\_gamerep::gameRepPlayerConnected();

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	bbPrint( "mpjoins", "name %s client %s", self.name, lpselfnum );
	
	if( !SessionModeIsZombiesGame() ) // it will be set after intro screen is faded out for zombie
	{
		self setClientUIVisibilityFlag( "hud_visible", 1 );
	}

	if ( level.forceRadar == 1 ) // radar always sweeping
	{
		self.pers["hasRadar"] = true;
		self.hasSpyplane = true;
		level.activeUAVs[self getEntityNumber()] = 1;
	}
	
	if ( level.forceRadar == 2 ) // radar constant
	{
		self setClientUIVisibilityFlag( "g_compassShowEnemies", level.forceRadar );
	}
	else
	{
		self SetClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
	}

	self SetClientPlayerSprintTime( level.playerSprintTime );
	self SetClientNumLives( level.numLives );

	makeDvarServerInfo( "cg_drawTalk", 1 );
	
	if ( level.hardcoreMode )
	{
		self SetClientDrawTalk( 3 );
	}

	if( SessionModeIsZombiesGame() )
	{
		// initial zombies stats 
		self [[level.player_stats_init]]();
	}
	else
	{
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "score" );
		if ( level.resetPlayerScoreEveryRound )
		{
			self.pers["score"] = 0;
		}
		self.score = self.pers["score"];

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "momentum", false );
		self.momentum = self  maps\mp\gametypes\_globallogic_score::getPersStat( "momentum" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "suicides" );
		self.suicides = self  maps\mp\gametypes\_globallogic_score::getPersStat( "suicides" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "headshots" );
		self.headshots = self  maps\mp\gametypes\_globallogic_score::getPersStat( "headshots" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "challenges" );
		self.challenges = self  maps\mp\gametypes\_globallogic_score::getPersStat( "challenges" );	

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "kills" );
		self.kills = self  maps\mp\gametypes\_globallogic_score::getPersStat( "kills" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "deaths" );
		self.deaths = self  maps\mp\gametypes\_globallogic_score::getPersStat( "deaths" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "assists" );
		self.assists = self  maps\mp\gametypes\_globallogic_score::getPersStat( "assists" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "defends", false );
		self.defends = self  maps\mp\gametypes\_globallogic_score::getPersStat( "defends" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "offends", false );
		self.offends = self  maps\mp\gametypes\_globallogic_score::getPersStat( "offends" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "plants", false );
		self.plants = self  maps\mp\gametypes\_globallogic_score::getPersStat( "plants" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "defuses", false );
		self.defuses = self  maps\mp\gametypes\_globallogic_score::getPersStat( "defuses" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "returns", false );
		self.returns = self  maps\mp\gametypes\_globallogic_score::getPersStat( "returns" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "captures", false );
		self.captures = self  maps\mp\gametypes\_globallogic_score::getPersStat( "captures" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "destructions", false );
		self.destructions = self  maps\mp\gametypes\_globallogic_score::getPersStat( "destructions" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "backstabs", false );
		self.backstabs = self  maps\mp\gametypes\_globallogic_score::getPersStat( "backstabs" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "longshots", false );
		self.longshots = self  maps\mp\gametypes\_globallogic_score::getPersStat( "longshots" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "survived", false );
		self.survived = self  maps\mp\gametypes\_globallogic_score::getPersStat( "survived" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "stabs", false );
		self.stabs = self  maps\mp\gametypes\_globallogic_score::getPersStat( "stabs" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "tomahawks", false );
		self.tomahawks = self  maps\mp\gametypes\_globallogic_score::getPersStat( "tomahawks" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "humiliated", false );
		self.humiliated = self  maps\mp\gametypes\_globallogic_score::getPersStat( "humiliated" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "x2score", false );
		self.x2score = self  maps\mp\gametypes\_globallogic_score::getPersStat( "x2score" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "agrkills", false );
		self.x2score = self  maps\mp\gametypes\_globallogic_score::getPersStat( "agrkills" );

		self  maps\mp\gametypes\_globallogic_score::initPersStat( "hacks", false );
		self.x2score = self  maps\mp\gametypes\_globallogic_score::getPersStat( "hacks" );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "sessionbans", false );
		self.sessionbans = self  maps\mp\gametypes\_globallogic_score::getPersStat( "sessionbans" );
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "gametypeban", false );
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "time_played_total", false );
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "time_played_alive", false );
	
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "teamkills", false );
		self  maps\mp\gametypes\_globallogic_score::initPersStat( "teamkills_nostats", false );
		self.teamKillPunish = false;
		if ( level.minimumAllowedTeamKills >= 0 && self.pers["teamkills_nostats"] > level.minimumAllowedTeamKills )
			self thread reduceTeamKillsOverTime();
	}
			
	if( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	
	self.killedPlayersCurrent = [];

	if( !isDefined( self.pers["best_kill_streak"] ) )
	{
		self.pers["killed_players"] = [];
		self.pers["killed_by"] = [];
		self.pers["nemesis_tracking"] = [];
		self.pers["artillery_kills"] = 0;
		self.pers["dog_kills"] = 0;
		self.pers["nemesis_name"] = "";
		self.pers["nemesis_rank"] = 0;
		self.pers["nemesis_rankIcon"] = 0;
		self.pers["nemesis_xp"] = 0;
		self.pers["nemesis_xuid"] = "";


		/*self.killstreakKills["artillery"] = 0;
		self.killstreakKills["dogs"] = 0;
		self.killstreaksUsed["radar"] = 0;
		self.killstreaksUsed["artillery"] = 0;
		self.killstreaksUsed["dogs"] = 0;*/
		self.pers["best_kill_streak"] = 0;
	}

// Adding Music tracking per player CDC
	if( !isDefined( self.pers["music"] ) )
	{
		self.pers["music"] = spawnstruct();
		self.pers["music"].spawn = false;
		self.pers["music"].inque = false;		
		self.pers["music"].currentState = "SILENT";
		self.pers["music"].previousState = "SILENT";
		self.pers["music"].nextstate = "UNDERSCORE";
		self.pers["music"].returnState = "UNDERSCORE";	
		
	}		
	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.currentLeaderDialogGroup = "";
	self.currentLeaderDialog = "";
	self.currentLeaderDialogTime = 0;

	if ( !isdefined( self.pers["cur_kill_streak"] ) )
	{
		self.pers["cur_kill_streak"] = 0;		
	}

	if ( !isdefined( self.pers["cur_total_kill_streak"] ) )
	{
		self.pers["cur_total_kill_streak"] = 0;
		self setplayercurrentstreak( 0 );
	}

	if ( !isdefined( self.pers["totalKillstreakCount"] ) )
		self.pers["totalKillstreakCount"] = 0;

	//Keep track of how many killstreaks have been earned in the current streak
	if ( !isdefined( self.pers["killstreaksEarnedThisKillstreak"] ) )
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	
	if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks && !IsDefined( self.pers["killstreak_quantity"] ) )
		self.pers["killstreak_quantity"] = [];

	if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks && !IsDefined( self.pers["held_killstreak_ammo_count"] ) )
		self.pers["held_killstreak_ammo_count"] = [];

	self.lastKillTime = 0;
	
	self.cur_death_streak = 0;
	self disabledeathstreak();
	self.death_streak = 0;
	self.kill_streak = 0;
	self.gametype_kill_streak = 0;
	self.spawnQueueIndex = -1;
	self.deathTime = 0;
	
	if ( level.onlineGame )
	{
		self.death_streak = self getDStat( "HighestStats",  "death_streak" );
		self.kill_streak = self getDStat( "HighestStats", "kill_streak" );
		self.gametype_kill_streak = self maps\mp\gametypes\_persistence::statGetWithGameType( "kill_streak" );
	}

	self.lastGrenadeSuicideTime = -1;

	self.teamkillsThisRound = 0;
	
	if ( !isDefined( level.livesDoNotReset ) || !level.livesDoNotReset || !isDefined( self.pers["lives"] ) )
		self.pers["lives"] = level.numLives;
		
	// multi round FFA games in custom game mode should maintain team in-between rounds
	if ( !level.teamBased )
	{
		self.pers["team"] = undefined;
	}
	
	self.hasSpawned = false;
	self.waitingToSpawn = false;
	self.wantSafeSpawn = false;
	self.deathCount = 0;
	
	self.wasAliveAtMatchStart = false;
	
	self thread maps\mp\_flashgrenades::monitorFlash();
	
	level.players[level.players.size] = self;
	
	if( level.splitscreen )
		SetDvar( "splitscreen_playerNum", level.players.size );
	// removed underscore for debug CDC
	//maps\mp\gametypes\_globallogic_audio::set_music_on_team( "UNDERSCORE", "both", true );;
	// When joining a game in progress, if the game is at the post game state (scoreboard) the connecting player should spawn into intermission
	if ( game["state"] == "postgame" )
	{
		self.pers["needteam"] = 1;
		self.pers["team"] = "spectator";
		self.team = "spectator";
	    self setClientUIVisibilityFlag( "hud_visible", 0 );
		
		self [[level.spawnIntermission]]();
		self closeMenu();
		self closeInGameMenu();
		profilelog_endtiming( 4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
		return;
	}

	// don't count losses for CTF and S&D and War at each round.
	if ( ( level.rankedMatch || level.wagerMatch ) && !isDefined( self.pers["lossAlreadyReported"] ) )
	{
			maps\mp\gametypes\_globallogic_score::updateLossStats( self );
			self.pers["lossAlreadyReported"] = true;
	}
	// don't redo winstreak save to pers array for each round of round based games.
	if ( !isDefined( self.pers["winstreakAlreadyCleared"] ) )
	{
			self  maps\mp\gametypes\_globallogic_score::backupAndClearWinStreaks();
			self.pers["winstreakAlreadyCleared"] = true;
	}
		
	if( self istestclient() )
	{
		self.pers[ "isBot" ] = true;
	}
	
	if ( level.rankedMatch || level.leagueMatch )
	{
		self maps\mp\gametypes\_persistence::setAfterActionReportStat( "demoFileID", "0" );
	}
	
	level endon( "game_ended" );

	if ( isDefined( level.hostMigrationTimer ) )
		self thread maps\mp\gametypes\_hostmigration::hostMigrationTimerThink();
	
	if ( level.oldschool )
	{
		self.pers["class"] = undefined;
		self.class = self.pers["class"];
	}

	if ( isDefined( self.pers["team"] ) )
		self.team = self.pers["team"];

	if ( isDefined( self.pers["class"] ) )
		self.class = self.pers["class"];
		
	if ( !isDefined( self.pers["team"] ) || IsDefined( self.pers["needteam"] ) )
	{
		// Don't set .sessionteam until we've gotten the assigned team from code,
		// because it overrides the assigned team.
		self.pers["needteam"] = undefined;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";
		
		self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		if ( level.rankedMatch )
		{
			[[level.autoassign]]( false );
			
			//self thread maps\mp\gametypes\_globallogic_spawn::forceSpawn();
			self thread maps\mp\gametypes\_globallogic_spawn::kickIfDontSpawn();
		}
		else
		{
			[[level.autoassign]]( false );
		}
		
		if ( self.pers["team"] == "spectator" )
		{
			self.sessionteam = "spectator";
			if ( !level.teamBased ) 
				self.ffateam = "spectator";
			self thread spectate_player_watcher();
		}
		
		if ( level.teamBased )
		{
			// set team and spectate permissions so the map shows waypoint info on connect
			self.sessionteam = self.pers["team"];
			if ( !isAlive( self ) )
				self.statusicon = "hud_status_dead";
			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
		}
	}
	else if ( self.pers["team"] == "spectator" )
	{
		self SetClientScriptMainMenu( game["menu_class"] );
		[[level.spawnSpectator]]();
		self.sessionteam = "spectator";
		self.sessionstate = "spectator";
		if ( !level.teamBased ) 
			self.ffateam = "spectator";
		self thread spectate_player_watcher();
	}
	else
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";

		if ( !level.teamBased ) 
				self.ffateam = self.pers["team"];
		
		self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		if ( maps\mp\gametypes\_globallogic_utils::isValidClass( self.pers["class"] ) )
		{
			self thread [[level.spawnClient]]();			
		}
		else
		{
			self maps\mp\gametypes\_globallogic_ui::showMainMenuForTeam();
		}
		
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
	}

	if ( self.sessionteam != "spectator" )
	{
		self thread maps\mp\gametypes\_spawning::onSpawnPlayer_Unified(true);
	}
	
	profilelog_endtiming( 4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );

	if ( isDefined( self.pers["isBot"] ) )
		return;
}

spectate_player_watcher()
{
	self endon( "disconnect" );
	
	self.watchingActiveClient = true;
	self.waitingForPlayersText = undefined;

	while ( 1 )
	{
		if ( self.pers["team"] != "spectator" || level.gameEnded )
		{
			self maps\mp\gametypes\_hud_message::clearShoutcasterWaitingMessage();
			self FreezeControls( false );
			self.watchingActiveClient = false;
			break;	
		}
		else
		{
			// Setup the perks hud elem for the spectator if its not yet initalized
			// We have to do it here, since the perk hudelem is generally initalized only on spawn, and the spectator will not able able to 
			// look at the perk loadout of some player.
			if ( !level.splitscreen && !level.hardcoreMode && GetDvarint( "scr_showperksonspawn" ) == 1 && game["state"] != "postgame" && !isdefined( self.perkHudelem ) )
			{
				if ( level.perksEnabled == 1 )
				{
					self maps\mp\gametypes\_hud_util::showPerks( );
				}
		
				self thread maps\mp\gametypes\_globallogic_ui::hideLoadoutAfterTime( 0 ); 
			}
			
			count = 0;
			for ( i = 0; i < level.players.size; i++ )
			{
				if ( level.players[i].team != "spectator" )
				{
					count++;
					break;					
				}
			}
			
			if ( count > 0 )
			{
				if ( !self.watchingActiveClient ) 
				{
					self maps\mp\gametypes\_hud_message::clearShoutcasterWaitingMessage();
					self FreezeControls( false );
				}
				
				self.watchingActiveClient = true;
			}
			else
			{
				if ( self.watchingActiveClient ) 
				{
					[[level.onSpawnSpectator]]();
					self FreezeControls( true );
					self maps\mp\gametypes\_hud_message::setShoutcasterWaitingMessage();
				}
				
				self.watchingActiveClient = false;
			}
			
			wait( 0.5 );
		}
	}
}

Callback_PlayerMigrated()
{
/#	println( "Player " + self.name + " finished migrating at time " + gettime() );	#/
	
	if ( isDefined( self.connected ) && self.connected )
	{
		self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();
//		self updateObjectiveText();
//		self updateMainMenu();

//		if ( level.teambased )
//			self updateScores();
	}
	
	level.hostMigrationReturnedPlayerCount++;
	if ( level.hostMigrationReturnedPlayerCount >= level.players.size * 2 / 3 )
	{
	/#	println( "2/3 of players have finished migrating" );	#/
		level notify( "hostmigration_enoughplayers" );
	}
}

Callback_PlayerDisconnect()
{
	profilelog_begintiming( 5, "ship" );

	if ( game["state"] != "postgame" && !level.gameEnded )
	{
		gameLength = maps\mp\gametypes\_globallogic::getGameLength();
		self maps\mp\gametypes\_globallogic::bbPlayerMatchEnd( gameLength, "MP_PLAYER_DISCONNECT", 0 );
	}

	self removePlayerOnDisconnect();

	if ( level.splitscreen )
	{
		players = level.players;
		
		if ( players.size <= 1 )
			level thread maps\mp\gametypes\_globallogic::forceEnd();
			
		// passing number of players to menus in splitscreen to display leave or end game option
		SetDvar( "splitscreen_playerNum", players.size );
	}

	if ( isDefined( self.score ) && isDefined( self.pers["team"] ) )
	{
		self logString( "team: score " + self.pers["team"] + ":" + self.score );
		level.dropTeam += 1;
	}
	
	[[level.onPlayerDisconnect]]();
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	//bbPrint( "mpquits", "name %s client %d", self.name, lpselfnum );

	self maps\mp\_gamerep::gameRepPlayerDisconnected();
	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].pers["killed_players"][self.name] ) )
			level.players[entry].pers["killed_players"][self.name] = undefined;

		if ( isDefined( level.players[entry].killedPlayersCurrent[self.name] ) )
			level.players[entry].killedPlayersCurrent[self.name] = undefined;

		if ( isDefined( level.players[entry].pers["killed_by"][self.name] ) )
			level.players[entry].pers["killed_by"][self.name] = undefined;

		if ( isDefined( level.players[entry].pers["nemesis_tracking"][self.name] ) )
			level.players[entry].pers["nemesis_tracking"][self.name] = undefined;
		
		// player that disconnected was our nemesis
		if ( level.players[entry].pers["nemesis_name"] == self.name )
		{
			level.players[entry] chooseNextBestNemesis();
		}
	}

	if ( level.gameEnded )
		self maps\mp\gametypes\_globallogic::removeDisconnectedPlayerFromPlacement();
	
	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	
	profilelog_endtiming( 5, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

chooseNextBestNemesis()
{
	nemesisArray = self.pers["nemesis_tracking"];
	nemesisArrayKeys = getArrayKeys( nemesisArray );
	nemesisAmount = 0;
	nemesisName = "";

	if ( nemesisArrayKeys.size > 0 )
	{
		for ( i = 0; i < nemesisArrayKeys.size; i++ )
		{
			nemesisArrayKey = nemesisArrayKeys[i];
			if ( nemesisArray[nemesisArrayKey] > nemesisAmount )
			{
				nemesisName = nemesisArrayKey;
				nemesisAmount = nemesisArray[nemesisArrayKey];
			}
			
		}
	}

	self.pers["nemesis_name"] = nemesisName;

	if ( nemesisName != "" )
	{
		playerIndex = 0;
		for( ; playerIndex < level.players.size; playerIndex++ )
		{
			if ( level.players[playerIndex].name == nemesisName )
			{
				nemesisPlayer = level.players[playerIndex];
				self.pers["nemesis_rank"] = nemesisPlayer.pers["rank"];
				self.pers["nemesis_rankIcon"] = nemesisPlayer.pers["rankxp"];
				self.pers["nemesis_xp"] = nemesisPlayer.pers["prestige"];
				self.pers["nemesis_xuid"] = nemesisPlayer GetXUID(true);
				break;
			}
		}
	}
	else
	{
		self.pers["nemesis_xuid"] = "";
	}
}

removePlayerOnDisconnect()
{
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
}

custom_gamemodes_modified_damage( victim, eAttacker, iDamage, sMeansOfDeath, sWeapon, eInflictor, sHitLoc )
{
	// regular public matches should early out
	if ( level.onlinegame && !SessionModeIsPrivate() )
	{
		return iDamage;
	}
	
	if( isdefined( eAttacker) &&  isDefined( eAttacker.damageModifier ) )
	{
		iDamage *= eAttacker.damageModifier;
	}
	if ( ( sMeansOfDeath == "MOD_PISTOL_BULLET" ) || ( sMeansOfDeath == "MOD_RIFLE_BULLET" ) )
	{
		iDamage = int( iDamage * level.bulletDamageScalar );
	}
	
	return iDamage;
}

figureOutAttacker( eAttacker )
{
	if ( isdefined(eAttacker) )
	{
		if( isai(eAttacker) && isDefined( eAttacker.script_owner ) )
		{
			team = self.team;
			
			if ( IsAi( self ) && IsDefined( self.aiteam ) )
			{
				team = self.aiteam;
			}

			if ( eAttacker.script_owner.team != team )
				eAttacker = eAttacker.script_owner;
		}
			
		if( eAttacker.classname == "script_vehicle" && isDefined( eAttacker.owner ) )
			eAttacker = eAttacker.owner;
		else if( eAttacker.classname == "auto_turret" && isDefined( eAttacker.owner ) )
			eAttacker = eAttacker.owner;
	}

	return eAttacker;
}

figureOutWeapon( sWeapon, eInflictor )
{
	// explosive barrel/car detection
	if ( sWeapon == "none" && isDefined( eInflictor ) )
	{
		if ( isDefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
		{
			sWeapon = "explodable_barrel_mp";
		}
		else if ( isDefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
		{
			sWeapon = "destructible_car_mp";
		}
	}

	return sWeapon;
}


isPlayerImmuneToKillstreak( eAttacker, sWeapon )
{
	if ( level.hardcoreMode )
		return false;
	
	if ( !IsDefined( eAttacker ) )
		return false;
	
	if ( self != eAttacker )
		return false;
	
	if ( sWeapon != "straferun_gun_mp" && sWeapon != "straferun_rockets_mp")
		return false;
	
	return true;
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	profilelog_begintiming( 6, "ship" );
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( self.sessionteam == "spectator" )
		return; 
	
	if ( isDefined( self.canDoCombat ) && !self.canDoCombat )
		return;
	
	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	if ( isDefined( level.hostMigrationTimer ) )
		return;

	if ( sWeapon == "emp_grenade_mp" )
	{
		self notify( "emp_grenaded", eAttacker );
	}

	if ( isdefined( eAttacker ) ) 
	{
		iDamage = maps\mp\gametypes\_class::cac_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, sWeapon, eInflictor, sHitLoc );
	}
	iDamage = custom_gamemodes_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, sWeapon, eInflictor, sHitLoc );
	
	iDamage = int(iDamage);
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();

	eAttacker = figureOutAttacker( eAttacker );

	pixbeginevent( "PlayerDamage flags/tweaks" );

	// Don't do knockback if the damage direction was not specified
	if( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = false;
	// Todo MGordon - Fix this stat collection
	//self thread  maps\mp\gametypes\_globallogic_score::threadedSetStatLBByName( sWeapon, 1, "hits by", 2 );

	// added check to notify chatter to play pain vo
	if ( self.health != self.maxhealth )
	{
		self notify( "snd_pain_player" );
	}	

	if ( IsDefined( eInflictor) && IsDefined( eInflictor.script_noteworthy) && eInflictor.script_noteworthy == "ragdoll_now" )
	{
		sMeansOfDeath = "MOD_FALLING";
	}

	if ( maps\mp\gametypes\_globallogic_utils::isHeadShot( sWeapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer(eAttacker) )
	{
		//Turning off damage headshot sounds to avoid confusion from the killing headshot sound.
		//if (self.team != eAttacker.team)
		//{
		//	eAttacker playLocalSound( "prj_bullet_impact_headshot_helmet_nodie_2d" );	
		//}
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	if ( level.onPlayerDamage != maps\mp\gametypes\_globallogic::blank )
	{
		modifiedDamage = [[level.onPlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		
		if ( isDefined( modifiedDamage ) )
		{
			if ( modifiedDamage <= 0 )
				return;

			iDamage = modifiedDamage;
		}
	}
	
	if ( level.onlyHeadShots )
	{
		if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
			return;
		else if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
			iDamage = 150;
	}
	
	// Make all vehicle drivers invulnerable to bullets
	if ( self maps\mp\_vehicles::player_is_occupant_invulnerable( sMeansOfDeath ) )
		return;

	if (isdefined (eAttacker) && isPlayer(eAttacker) && (self.team != eAttacker.team))
	{
		self.lastAttackWeapon = sWeapon;
	}
	
	sWeapon = figureOutWeapon( sWeapon, eInflictor );

	pixendevent(); //  "END: PlayerDamage flags/tweaks"
	
	if( iDFlags & level.iDFLAGS_PENETRATION && isplayer ( eAttacker ) && eAttacker hasPerk( "specialty_bulletpenetration" ) )
		self thread maps\mp\gametypes\_battlechatter_mp::perkSpecificBattleChatter( "deepimpact", true );

	attackerIsHittingTeammate = isPlayer( eAttacker ) && ( self IsEnemyPlayer( eAttacker ) == false );

	if ( sHitLoc == "riotshield" )
	{
		if ( attackerIsHittingTeammate && level.friendlyfire == 0 )
		{
			return;
		}

		if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" && !attackerIsHittingTeammate )
		{
			if ( !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ))
			{
				previous_shield_damage = self.shieldDamageBlocked;
				self.shieldDamageBlocked += iDamage;

				if ( isPlayer( eAttacker ))
				{
					eAttacker.lastAttackedShieldPlayer = self;
					eAttacker.lastAttackedShieldTime = getTime();
				}
				//victim notify ( "shield_blocked" ); // tagTMR<TODO>: for incrementing player stats for shield blocks
 
				if (( self.shieldDamageBlocked % 400 /*riotshield_damage_score_threshold*/ ) < ( previous_shield_damage % 400 /*riotshield_damage_score_threshold*/ ))
				{
					score_event = "shield_blocked_damage";

					if (( self.shieldDamageBlocked > 2000 /*riotshield_damage_score_max*/ ))
					{
						score_event = "shield_blocked_damage_reduced";	
					}

					thread maps\mp\_scoreevents::processScoreEvent( score_event, self );
				}
			}
		}

		if ( iDFlags & level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT )
		{
			sHitLoc = "none";	// code ignores any damage to a "shield" bodypart.
			if ( !(iDFlags & level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE) )
			{
				iDamage *= 0.0;
			}
		}
		else if ( iDFlags & level.iDFLAGS_SHIELD_EXPLOSIVE_SPLASH )
		{
			if ( isDefined( eInflictor ) && isDefined( eInflictor.stuckToPlayer ) && eInflictor.stuckToPlayer == self )
			{
				//does enough damage to shield carrier to ensure death		
				iDamage = 101;
			}

			sHitLoc = "none";
		}
		else
		{
			return;
		}		
	}

	// check for completely getting out of the damage
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		if ( IsDefined( eInflictor ) && ( sMeansOfDeath == "MOD_GAS" || maps\mp\gametypes\_class::isExplosiveDamage( undefined, sMeansOfDeath ) ) )
		{
			// protect players from spawnkill grenades, tabun and incendiary
			if ( ( eInflictor.classname == "grenade" || sweapon == "tabun_gas_mp" )  && (self.lastSpawnTime + 3500) > getTime() && DistanceSquared( eInflictor.origin, self.lastSpawnPoint.origin ) < 250 * 250 )
			{
//				pixmarker( "END: Callback_PlayerDamage player" );
				return;
			}
			
			// protect players from their own non-player controlled killstreaks
			if ( self isPlayerImmuneToKillstreak( eAttacker, sWeapon ) )
			{
				return;
			}
			
			self.explosiveInfo = [];
			self.explosiveInfo["damageTime"] = getTime();
			self.explosiveInfo["damageId"] = eInflictor getEntityNumber();
			self.explosiveInfo["originalOwnerKill"] = false;
			self.explosiveInfo["bulletPenetrationKill"] = false;
			self.explosiveInfo["chainKill"]  = false;
			self.explosiveInfo["damageExplosiveKill"] = false;
			self.explosiveInfo["chainKill"] = false;
			self.explosiveInfo["cookedKill"] = false;
			self.explosiveInfo["weapon"] = sWeapon;
			self.explosiveInfo["originalowner"] = eInflictor.originalowner;
			
			isFrag = ( sWeapon == "frag_grenade_mp" );

			if ( IsDefined( eAttacker ) && eAttacker != self )
			{
				if ( isDefined( eAttacker ) && isDefined( eInflictor.owner ) && ( sWeapon == "satchel_charge_mp" || sWeapon == "claymore_mp" || sWeapon == "bouncingbetty_mp" ) )
				{
					self.explosiveInfo["originalOwnerKill"] = (eInflictor.owner == self);
					self.explosiveInfo["damageExplosiveKill"] = isDefined( eInflictor.wasDamaged );
					self.explosiveInfo["chainKill"] = isDefined( eInflictor.wasChained );
					self.explosiveInfo["wasJustPlanted"] = isDefined( eInflictor.wasJustPlanted );
					self.explosiveInfo["bulletPenetrationKill"] = isDefined( eInflictor.wasDamagedFromBulletPenetration );
					self.explosiveInfo["cookedKill"] = false;
				}
				if ( ( sWeapon == "sticky_grenade_mp" || sWeapon == "explosive_bolt_mp"  ) && isDefined( eInflictor ) && isdefined( eInflictor.stuckToPlayer ) )
				{
					self.explosiveInfo["stuckToPlayer"] = eInflictor.stuckToPlayer;
				}
				if ( sWeapon == "proximity_grenade_mp" || sWeapon == "proximity_grenade_aoe_mp"  )  
				{
					self.lastStunnedBy = eAttacker;
					self.lastStunnedTime = self.iDFlagsTime;
				}
				if ( isDefined( eAttacker.lastGrenadeSuicideTime ) && eAttacker.lastGrenadeSuicideTime >= gettime() - 50 && isFrag )
				{
					self.explosiveInfo["suicideGrenadeKill"] = true;
				}
				else
				{
					self.explosiveInfo["suicideGrenadeKill"] = false;
				}
			}
			
			if ( isFrag )
			{
				self.explosiveInfo["cookedKill"] = isDefined( eInflictor.isCooked );
				self.explosiveInfo["throwbackKill"] = isDefined( eInflictor.threwBack );
			}

			if( IsDefined( eAttacker ) && isPlayer( eAttacker ) && eAttacker != self )
			{
				self maps\mp\gametypes\_globallogic_score::setInflictorStat( eInflictor, eAttacker, sWeapon );
			}
		}

		if( sMeansOfDeath == "MOD_IMPACT" && isDefined( eAttacker ) && isPlayer( eAttacker ) && eAttacker != self )
		{
			if ( sWeapon != "knife_ballistic_mp" )
			{
				self maps\mp\gametypes\_globallogic_score::setInflictorStat( eInflictor, eAttacker, sWeapon );
			}

			if ( sWeapon == "hatchet_mp" && isDefined( eInflictor ) )
			{
				self.explosiveInfo["projectile_bounced"] = isDefined( eInflictor.bounced );
			}
		}
		
		if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
		
		prevHealthRatio = self.health / self.maxhealth;
		
		if ( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.team == eAttacker.team) )
		{
			pixmarker( "BEGIN: PlayerDamage player" ); // profs automatically end when the function returns
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				if ( sWeapon == "artillery_mp" || sWeapon == "airstrike_mp" || sWeapon == "napalm_mp" || sWeapon == "mortar_mp" )
					self damageShellshockAndRumble( eAttacker, eInflictor, sWeapon, sMeansOfDeath, iDamage );
				return;
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;

				//check for friendly fire at the begining of the match. apply the damage to the attacker only
				if( level.friendlyFireDelay && level.friendlyFireDelayTime >= ( ( ( gettime() - level.startTime ) - level.discardTime ) / 1000 ) )
				{
					eAttacker.lastDamageWasFromEnemy = false;
				
					eAttacker.friendlydamage = true;
					eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
					eAttacker.friendlydamage = undefined;
				}
				else
				{
					self.lastDamageWasFromEnemy = false;
					
					self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				}
			}
			else if ( level.friendlyfire == 2 && isAlive( eAttacker ) ) // only the attacker takes damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				
				eAttacker.lastDamageWasFromEnemy = false;
				
				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			else if ( level.friendlyfire == 3 && isAlive( eAttacker ) ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				eAttacker.lastDamageWasFromEnemy = false;
				
				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			
			friendly = true;
			pixmarker( "END: PlayerDamage player" );
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && allowedAssistWeapon( sWeapon ) )
			{				
				self trackAttackerDamage( eAttacker, iDamage, sMeansOfDeath, sWeapon );
			}
		
			giveInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, sWeapon );
	
			if ( isdefined( eAttacker ) )
				level.lastLegitimateAttacker = eAttacker;

			if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( sWeapon ) && !issubstr( sMeansOfDeath, "MOD_MELEE" ) )
				eAttacker thread maps\mp\gametypes\_weapons::checkHit( sWeapon );

			if ( ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" ) && isDefined( eInflictor.isCooked ) )
				self.wasCooked = getTime();
			else
				self.wasCooked = undefined;
			
			self.lastDamageWasFromEnemy = (isDefined( eAttacker ) && (eAttacker != self));

			if ( self.lastDamageWasFromEnemy )
				eAttacker.damagedPlayers[ self.clientId ] = getTime();
			
			self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			//self thread maps\mp\gametypes\_missions::playerDamaged(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
		}

		if ( isdefined(eAttacker) && isplayer( eAttacker ) && eAttacker != self )
		{			
			if ( doDamageFeedback( sWeapon, eInflictor, iDamage, sMeansOfDeath ) )
			{
				if ( iDamage > 0 )
				{
					// the perk feedback should be shown only if the enemy is damaged and not killed. 
					if ( self.health > 0 ) 
					{
						perkFeedback = doPerkFeedBack( self, sWeapon, sMeansOfDeath, eInflictor );
					}
					
					eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( sMeansOfDeath, eInflictor, perkFeedback );
				}
			}
		}
		
		self.hasDoneCombat = true;
	}

	if(self.sessionstate != "dead")
		self maps\mp\gametypes\_gametype_variants::onPlayerTakeDamage( eAttacker, eInflictor, sWeapon, iDamage, sMeansOfDeath );

	if ( isdefined( eAttacker ) && eAttacker != self && !friendly )
		level.useStartSpawns = false;

	pixbeginevent( "PlayerDamage log" );

/#
	// Do debug print if it's enabled
	if(GetDvarint( "g_debugDamage"))
		println("client:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);
#/

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.team;
		lpselfGuid = self getGuid();
		lpattackerteam = "";
		lpattackerorigin = ( 0, 0, 0 );

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.team;
			lpattackerorigin = eAttacker.origin;
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d",
				           gettime(), getplayerspawnid( eAttacker ), sWeapon, lpattackerorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 0 ); 
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
			bbPrint( "mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d",
				           gettime(), sWeapon, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 0 ); 
		}
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
	
	pixendevent(); // "END: PlayerDamage log"
	
	profilelog_endtiming( 6, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

resetAttackerList()
{
	self.attackers = [];
	self.attackerData = [];
	self.attackerDamage = [];
	self.firstTimeDamaged = 0;
}

doDamageFeedback( sWeapon, eInflictor, iDamage, sMeansOfDeath )
{
	if ( !IsDefined( sWeapon ) )
		return false;

	if ( level.allowHitMarkers == 0 ) 
		return false;

	if ( level.allowHitMarkers == 1 ) // no tac grenades
	{
		if ( isdefined( sMeansOfDeath ) && isdefined( iDamage ) ) 
		{
			if ( isTacticalHitMarker( sWeapon, sMeansOfDeath, iDamage ) )
			{
				return false;
			}
		}
	}

	return true;
}

isTacticalHitMarker( sWeapon, sMeansOfDeath, iDamage )
{

	if ( isGrenade( sWeapon ) )
	{
		if ( sWeapon == "willy_pete_mp" ) 
		{
			if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
				return true;
		}
		else if ( iDamage == 1 )
		{
			return true;
		}
	}	
	return false;
}

doPerkFeedBack( player, sWeapon, sMeansOfDeath, eInflictor )
{
	perkFeedback = undefined;
	hasTacticalMask = maps\mp\gametypes\_class::hasTacticalMask( player );
	hasFlakJacket = ( player HasPerk( "specialty_flakjacket" ) );
	isExplosiveDamage = maps\mp\gametypes\_class::isExplosiveDamage( sWeapon, sMeansOfDeath );
	isFlashOrStunDamage = maps\mp\gametypes\_weapon_utils::isFlashOrStunDamage( sWeapon, sMeansOfDeath );
						
	if ( isFlashOrStunDamage && hasTacticalMask )
	{
		perkFeedback = "tacticalMask";  
	}
	else if ( isExplosiveDamage && hasFlakJacket && ( !isAIKillstreakDamage( sWeapon, eInflictor ) ) )
	{
		perkFeedback = "flakjacket";   	
	}

	return perkFeedback;
}

isAIKillstreakDamage( sWeapon, eInflictor )
{
	switch ( sWeapon )
	{
		case "ai_tank_drone_rocket_mp":
			return ( isDefined( eInflictor.firedByAI ) );
		case "missile_swarm_projectile_mp":
			return true;
		case "planemortar_mp":
			return true;
		case "chopper_minigun_mp":
			return true;
		case "straferun_rockets_mp":
			return true;
		case "littlebird_guard_minigun_mp":
			return true;
		case "cobra_20mm_comlink_mp":
			return true;
	}
	
	return false;
}

finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{	
	pixbeginevent("finishPlayerDamageWrapper");

	if( !level.console && iDFlags & level.iDFLAGS_PENETRATION && isplayer ( eAttacker ) )
	{
		/#
		println("penetrated:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);
		#/
		eAttacker AddPlayerStat( "penetration_shots", 1 );
	}
	
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	if ( GetDvar( "scr_csmode" ) != "" )
		self shellShock( "damage_mp", 0.2 );
	
	self damageShellshockAndRumble( eAttacker, eInflictor, sWeapon, sMeansOfDeath, iDamage );
	pixendevent();
}

allowedAssistWeapon( weapon )
{
	if ( !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon ) )
		return true;
		
	if (maps\mp\killstreaks\_killstreaks::isKillstreakWeaponAssistAllowed(  weapon ) )
		return true;
		
	return false;
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	profilelog_begintiming( 7, "ship" );
	
	self endon( "spawned" );
	self notify( "killed_player" );

	if ( self.sessionteam == "spectator" )
		return;
	
	if ( game["state"] == "postgame" )
		return;	

	self needsRevive( false );

	if ( isdefined( self.burning ) && self.burning == true )
	{
		self setburn( 0 );
	}

	self.suicide = false;
	
	if ( isDefined( level.takeLivesOnDeath ) && ( level.takeLivesOnDeath == true ) )
	{
		if ( self.pers["lives"] )
		{
			self.pers["lives"]--;
			if ( self.pers["lives"] == 0 )
			{
				level notify( "player_eliminated" );
				self notify( "player_eliminated" );
			}

		}
	}

	sWeapon = updateWeapon( eInflictor, sWeapon );
	
	pixbeginevent( "PlayerKilled pre constants" );
	
	wasInLastStand = false;
	deathTimeOffset = 0;
	lastWeaponBeforeDroppingIntoLastStand = undefined;
	attackerStance = undefined;
	self.lastStandThisLife = undefined;
	self.vAttackerOrigin = undefined;
					
	if ( isdefined( self.useLastStandParams ) )
	{
		self.useLastStandParams = undefined;
		
		assert( isdefined( self.lastStandParams ) );
		if ( !level.teamBased || ( !isDefined( attacker ) || !isplayer( attacker ) || attacker.team != self.team || attacker == self ) )
		{
			eInflictor = self.lastStandParams.eInflictor;
			attacker = self.lastStandParams.attacker;
			attackerStance = self.lastStandParams.attackerStance;
			iDamage = self.lastStandParams.iDamage;
			sMeansOfDeath = self.lastStandParams.sMeansOfDeath;
			sWeapon = self.lastStandParams.sWeapon;
			vDir = self.lastStandParams.vDir;
			sHitLoc = self.lastStandParams.sHitLoc;
			self.vAttackerOrigin = self.lastStandParams.vAttackerOrigin;
			deathTimeOffset = (gettime() - self.lastStandParams.lastStandStartTime) / 1000;
			
			self thread maps\mp\gametypes\_battlechatter_mp::perkSpecificBattleChatter( "secondchance" );
			
			if ( isDefined( self.previousPrimary ) )
			{
				wasInLastStand = true;
				lastWeaponBeforeDroppingIntoLastStand = self.previousPrimary;
			}
		}
		self.lastStandParams = undefined;
	}

	bestPlayer = undefined;
	bestPlayerMeansOfDeath = undefined;
	obituaryMeansOfDeath = undefined;
	bestPlayerWeapon = undefined;
	obituaryWeapon = undefined;

	if ( (!isDefined( attacker ) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || ( isdefined( attacker.isMagicBullet ) && attacker.isMagicBullet == true ) || attacker == self ) && isDefined( self.attackers )  )
	{		
		if ( !isDefined(bestPlayer) )
		{
			for ( i = 0; i < self.attackers.size; i++ )
			{
				player = self.attackers[i];
				if ( !isDefined( player ) )
					continue;
				
				if (!isDefined( self.attackerDamage[ player.clientId ] ) || ! isDefined( self.attackerDamage[ player.clientId ].damage ) )
					continue;
				
				if ( player == self || (level.teamBased && player.team == self.team ) )
					continue;
				
				if ( self.attackerDamage[ player.clientId ].lasttimedamaged + 2500 < getTime() )
					continue;			
	
				if ( !allowedAssistWeapon( self.attackerDamage[ player.clientId ].weapon ) )
					continue;
	
				if ( self.attackerDamage[ player.clientId ].damage > 1 && ! isDefined( bestPlayer ) )
				{
					bestPlayer = player;
					bestPlayerMeansOfDeath = self.attackerDamage[ player.clientId ].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[ player.clientId ].weapon;
				}
				else if ( isDefined( bestPlayer ) && self.attackerDamage[ player.clientId ].damage > self.attackerDamage[ bestPlayer.clientId ].damage )
				{
					bestPlayer = player;	
					bestPlayerMeansOfDeath = self.attackerDamage[ player.clientId ].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[ player.clientId ].weapon;
				}
			}
		}
		if ( isdefined ( bestPlayer ) )
		{
			maps\mp\_scoreevents::processScoreEvent( "assisted_suicide", bestPlayer, self, sWeapon, true );
			self recordKillModifier("assistedsuicide");
		}
	}
	
	if ( isdefined ( bestPlayer ) )
	{
		attacker = bestPlayer;
		obituaryMeansOfDeath = bestPlayerMeansOfDeath;
		obituaryWeapon = bestPlayerWeapon;
	}

	if ( isplayer( attacker ) )
		attacker.damagedPlayers[self.clientid] = undefined;

	if( maps\mp\gametypes\_globallogic_utils::isHeadShot( sWeapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer( attacker ) )
	{
		attacker playLocalSound( "prj_bullet_impact_headshot_helmet_nodie_2d" );
		//attacker playLocalSound( "prj_bullet_impact_headshot_2d" );

		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	self.deathTime = getTime();
		
	attacker = updateAttacker( attacker );
	eInflictor = updateInflictor( eInflictor );

	sMeansOfDeath = updateMeansOfDeath( sWeapon, sMeansOfDeath );
	
	if ( isdefined(self.hasRiotShieldEquipped) && (self.hasRiotShieldEquipped==true) )
	{
		self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
		self.hasRiotShield = false;
		self.hasRiotShieldEquipped = false;
	}

	self thread updateGlobalBotKilledCounter();
	if ( !SessionModeIsZombiesGame() && maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
	{
		level.globalKillstreaksDeathsFrom++;
	}

	// Don't increment weapon stats for team kills or deaths
	if ( isPlayer( attacker ) && attacker != self && ( !level.teamBased || ( level.teamBased && self.team != attacker.team ) ) )
	{
		self AddWeaponStat( sWeapon, "deaths", 1 ); 

		if ( wasInLastStand && isDefined( lastWeaponBeforeDroppingIntoLastStand ) ) 
			weaponName = lastWeaponBeforeDroppingIntoLastStand;
		else
			weaponName = self.lastdroppableweapon;

		if ( isDefined( weaponName ) && ( isSubStr( weaponName, "gl_" ) || isSubStr( weaponName, "mk_" ) || isSubStr( weaponName, "ft_" ) ) )
			weaponName = self.currentWeapon;
	
		if ( isDefined( weaponName ) )
		{
			self AddWeaponStat( weaponName, "deathsDuringUse", 1 );
		}
		
		if ( sMeansOfDeath != "MOD_FALLING" )
		{
			attacker AddWeaponStat( sWeapon, "kills", 1 );
		}
		
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
		{
			attacker AddWeaponStat( sWeapon, "headshots", 1 );
		}
	}
	
	if ( !isdefined( obituaryMeansOfDeath ) ) 
		obituaryMeansOfDeath = sMeansOfDeath;
	if ( !isdefined( obituaryWeapon ) ) 
		obituaryWeapon = sWeapon;


	if ( !isplayer( attacker ) || ( self IsEnemyPlayer( attacker ) == false ) )
	{
		level notify( "reset_obituary_count" );
		level.lastObituaryPlayerCount = 0;
		level.lastObituaryPlayer = undefined;
	}
	else
	{
		if ( isdefined( level.lastObituaryPlayer ) && level.lastObituaryPlayer == attacker ) 
		{
			level.lastObituaryPlayerCount++;
		}
		else
		{
			level notify( "reset_obituary_count" );
			level.lastObituaryPlayer = attacker;
			level.lastObituaryPlayerCount = 1;
		}

		level thread maps\mp\_scoreevents::decrementLastObituaryPlayerCountAfterFade();

		if ( level.lastObituaryPlayerCount >= 4 ) 
		{
			level notify( "reset_obituary_count" );
			level.lastObituaryPlayerCount = 0;
			level.lastObituaryPlayer = undefined;
			maps\mp\_scoreevents::processScoreEvent( "uninterrupted_obit_feed_kills", attacker, self, sWeapon, true );

		}
	}


	// send out an obituary message to all clients about the kill
	if( level.teamBased && isDefined( attacker.pers ) && self.team == attacker.team && obituaryMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
	{
		obituary(self, self, obituaryWeapon, obituaryMeansOfDeath);
		maps\mp\_demo::bookmark( "kill", gettime(), self, self, eInflictor, sweapon );
	}
	else
	{
		obituary(self, attacker, obituaryWeapon, obituaryMeansOfDeath);
		maps\mp\_demo::bookmark( "kill", gettime(), self, attacker, eInflictor, sweapon );
	}

	if ( !level.inGracePeriod )
	{
		self maps\mp\gametypes\_weapons::dropScavengerForDeath( attacker );
		self maps\mp\gametypes\_weapons::dropWeaponForDeath( attacker );
		self maps\mp\gametypes\_weapons::dropOffhand();
	}

	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;
	
	self.killedPlayersCurrent = [];
	
	self.deathCount++;

/#
	println( "players("+self.clientId+") death count ++: " + self.deathCount );
#/

	if( !isDefined( self.switching_teams ) )
	{
		// if team killed we reset kill streak, but dont count death and death streak
		if ( isPlayer( attacker ) && level.teamBased && ( attacker != self ) && ( self.team == attacker.team ) )
		{		
								
			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak( 0 );
		}
		else
		{		
			self  maps\mp\gametypes\_globallogic_score::incPersStat( "deaths", 1, true, true );
			self.deaths = self  maps\mp\gametypes\_globallogic_score::getPersStat( "deaths" );	
			self  UpdateStatRatio( "kdratio", "kills", "deaths" );

			if( self.pers["cur_kill_streak"] > self.pers["best_kill_streak"] )
				self.pers["best_kill_streak"] = self.pers["cur_kill_streak"];

			// need to keep the current killstreak to see if this was a buzzkill later
			self.pers["kill_streak_before_death"] = self.pers["cur_kill_streak"];


			self.pers["cur_kill_streak"] = 0;
			self.pers["cur_total_kill_streak"] = 0;
			self.pers["totalKillstreakCount"] = 0;
			self.pers["killstreaksEarnedThisKillstreak"] = 0;
			self setplayercurrentstreak( 0 );

			self.cur_death_streak++;

			if ( self.cur_death_streak > self.death_streak )
			{
				if ( level.rankedMatch ) 
				{
					self setDStat( "HighestStats", "death_streak", self.cur_death_streak );
				}
				self.death_streak = self.cur_death_streak;
			}
			
			if( self.cur_death_streak >= GetDvarint( "perk_deathStreakCountRequired" ) )
			{
				self enabledeathstreak();
			}
		}
	}
	else
	{
		self.pers["totalKillstreakCount"] = 0;
		self.pers["killstreaksEarnedThisKillstreak"] = 0;
	}
	
	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = self.team;
	lpselfguid = self getGuid();
	lpattackteam = "";
	lpattackorigin = ( 0, 0, 0 );

	lpattacknum = -1;

	//check if we should award assist points
	awardAssists = false;

	pixendevent(); // "PlayerKilled pre constants" );

	maps\mp\_scoreevents::processScoreEvent( "death", self, self, sWeapon );

	if( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackteam = attacker.team;
		lpattackorigin = attacker.origin;

		if ( attacker == self ) // killed himself
		{
			doKillcam = false;
			
			// switching teams
			if ( isDefined( self.switching_teams ) )
			{
				if ( !level.teamBased && ( isdefined( level.teams[ self.leaving_team ] ) &&  isdefined( level.teams[ self.joining_team ] ) && level.teams[ self.leaving_team ] != level.teams[ self.joining_team ] ) )
				{
					playerCounts = self maps\mp\teams\_teams::CountPlayers();
					playerCounts[self.leaving_team]--;
					playerCounts[self.joining_team]++;
				
					if( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
					{
						thread maps\mp\_scoreevents::processScoreEvent( "suicide", self );
						self thread maps\mp\gametypes\_rank::giveRankXP( "suicide" );	
						self  maps\mp\gametypes\_globallogic_score::incPersStat( "suicides", 1 );
						self.suicides = self  maps\mp\gametypes\_globallogic_score::getPersStat( "suicides" );
					}
				}
			}
			else
			{
				thread maps\mp\_scoreevents::processScoreEvent( "suicide", self );
				self  maps\mp\gametypes\_globallogic_score::incPersStat( "suicides", 1 );
				self.suicides = self  maps\mp\gametypes\_globallogic_score::getPersStat( "suicides" );

				if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade )
				{
					self.lastGrenadeSuicideTime = gettime();
				}

				//Check for player death related battlechatter
				thread maps\mp\gametypes\_battlechatter_mp::onPlayerSuicideOrTeamKill( self, "suicide" );	//Play suicide battlechatter
				
				//check if assist points should be awarded
				awardAssists = true;
				self.suicide = true;
			}
			
			if( isDefined( self.friendlydamage ) )
			{
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");
				if ( level.teamKillPointLoss )
					{
						scoreSub = self [[level.getTeamKillScore]]( eInflictor, attacker, sMeansOfDeath, sWeapon);
						maps\mp\gametypes\_globallogic_score::_setPlayerScore( attacker,maps\mp\gametypes\_globallogic_score::_getPlayerScore( attacker ) - scoreSub );
					}
			}
		}
		else
		{
			pixbeginevent( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;
			
			self thread maps\mp\gametypes\_gametype_variants::playerKilled( attacker );

			if ( level.teamBased && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
			{		
			}
			else if ( level.teamBased && self.team == attacker.team ) // killed by a friendly
			{
				thread maps\mp\_scoreevents::processScoreEvent( "team_kill", attacker );
		
				if ( !IgnoreTeamKills( sWeapon, sMeansOfDeath ) )
				{
					teamkill_penalty = self [[level.getTeamKillPenalty]]( eInflictor, attacker, sMeansOfDeath, sWeapon);
				
					attacker  maps\mp\gametypes\_globallogic_score::incPersStat( "teamkills_nostats", teamkill_penalty, false );
					attacker  maps\mp\gametypes\_globallogic_score::incPersStat( "teamkills", 1 ); //save team kills to player stats
					attacker.teamkillsThisRound++;
				
					if ( level.teamKillPointLoss )
					{
						scoreSub = self [[level.getTeamKillScore]]( eInflictor, attacker, sMeansOfDeath, sWeapon);
						maps\mp\gametypes\_globallogic_score::_setPlayerScore( attacker,maps\mp\gametypes\_globallogic_score::_getPlayerScore( attacker ) - scoreSub );
					}
					
					if ( maps\mp\gametypes\_globallogic_utils::getTimePassed() < 5000 )
						teamKillDelay = 1;
					else if ( attacker.pers["teamkills_nostats"] > 1 && maps\mp\gametypes\_globallogic_utils::getTimePassed() < (8000 + (attacker.pers["teamkills_nostats"] * 1000)) )
						teamKillDelay = 1;
					else
						teamKillDelay = attacker TeamKillDelay();
						
					if ( teamKillDelay > 0 )
					{
						attacker.teamKillPunish = true;
						attacker suicide();
						
						if ( attacker ShouldTeamKillKick(teamKillDelay) )
						{
							attacker TeamKillKick();
						}
	
						attacker thread reduceTeamKillsOverTime();			
					}
	
					//Play teamkill battlechatter
					if( isPlayer( attacker ) )
						thread maps\mp\gametypes\_battlechatter_mp::onPlayerSuicideOrTeamKill( attacker, "teamkill" );
				}
			}
			else
			{
				maps\mp\gametypes\_globallogic_score::incTotalKills(attacker.team);
				
				attacker thread maps\mp\gametypes\_globallogic_score::giveKillStats( sMeansOfDeath, sWeapon, self );

				if ( isAlive( attacker ) )
				{
					pixbeginevent("killstreak");

					if ( !isDefined( eInflictor ) || !isDefined( eInflictor.requiredDeathCount ) || attacker.deathCount == eInflictor.requiredDeathCount )
					{
						shouldGiveKillstreak = maps\mp\killstreaks\_killstreaks::shouldGiveKillstreak( sWeapon );
						//attacker thread maps\mp\_properks::earnedAKill();

						if ( shouldGiveKillstreak )
						{
							attacker maps\mp\killstreaks\_killstreaks::addToKillstreakCount(sWeapon);
						}

						attacker.pers["cur_total_kill_streak"]++;
						attacker setplayercurrentstreak( attacker.pers["cur_total_kill_streak"] );

						//Kills gotten through killstreak weapons should not the players killstreak
						if ( isDefined( level.killstreaks ) &&  shouldGiveKillstreak )
						{	
							attacker.pers["cur_kill_streak"]++;
							
							if ( attacker.pers["cur_kill_streak"] >= 3 ) 
							{
								if ( attacker.pers["cur_kill_streak"] <= 30 ) 
								{
									maps\mp\_scoreevents::processScoreEvent( "killstreak_" + attacker.pers["cur_kill_streak"], attacker, self, sWeapon );
								}
								else
								{
									maps\mp\_scoreevents::processScoreEvent( "killstreak_more_than_30", attacker, self, sWeapon );
								}
							}

							//attacker thread maps\mp\_properks::checkKillCount();

							if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum )
							{
								attacker thread maps\mp\killstreaks\_killstreaks::giveKillstreakForStreak();
							}
						}
					}
				
					if( isPlayer( attacker ) )
						self thread maps\mp\gametypes\_battlechatter_mp::onPlayerKillstreak( attacker );

					pixendevent(); // "killstreak"
				}
 	
				if ( attacker.pers["cur_kill_streak"] > attacker.kill_streak )
				{
					if ( level.rankedMatch ) 
					{
						attacker setDStat( "HighestStats", "kill_streak", attacker.pers["totalKillstreakCount"] );
					}
					attacker.kill_streak = attacker.pers["cur_kill_streak"];
				}
				

				if ( attacker.pers["cur_kill_streak"] > attacker.gametype_kill_streak )
				{
					attacker maps\mp\gametypes\_persistence::statSetWithGametype( "kill_streak", attacker.pers["cur_kill_streak"] );
					attacker.gametype_kill_streak = attacker.pers["cur_kill_streak"];
				}
				
				killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( sWeapon );

				if ( IsDefined( killstreak ) )
				{
					if ( maps\mp\gametypes\_rank::isRegisteredEvent( killstreak ) )
					{
						maps\mp\_scoreevents::processScoreEvent( killstreak, attacker, self, sWeapon );
					}
				}
				else
				{
					maps\mp\_scoreevents::processScoreEvent( "kill", attacker, self, sWeapon );
					if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
					{
						maps\mp\_scoreevents::processScoreEvent( "headshot", attacker, self, sWeapon, true );
					}
					else if ( sMeansOfDeath == "MOD_MELEE" )
					{		
						if ( sWeapon == "riotshield_mp" )
						{
							maps\mp\_scoreevents::processScoreEvent( "melee_kill_with_riot_shield", attacker, self, sWeapon, true );
						}
						else
						{
							maps\mp\_scoreevents::processScoreEvent( "melee_kill", attacker, self, sWeapon );
						}
					
					}
				}

				attacker thread  maps\mp\gametypes\_globallogic_score::trackAttackerKill( self.name, self.pers["rank"], self.pers["rankxp"], self.pers["prestige"], self getXuid(true) );	
				
				attackerName = attacker.name;
				self thread  maps\mp\gametypes\_globallogic_score::trackAttackeeDeath( attackerName, attacker.pers["rank"], attacker.pers["rankxp"], attacker.pers["prestige"], attacker getXuid(true) );
				self thread maps\mp\_medals::setLastKilledBy( attacker );

				attacker thread  maps\mp\gametypes\_globallogic_score::incKillstreakTracker( sWeapon );
				
				// to prevent spectator gain score for team-spectator after throwing a granade and killing someone before he switched
				if ( level.teamBased && attacker.team != "spectator")
				{
					// dog score for team
					if( isai(Attacker) )
						maps\mp\gametypes\_globallogic_score::giveTeamScore( "kill", attacker.aiteam, attacker, self );
					else
						maps\mp\gametypes\_globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
				}

				scoreSub = level.deathPointLoss;
				if ( scoreSub != 0 )
				{
					maps\mp\gametypes\_globallogic_score::_setPlayerScore( self, maps\mp\gametypes\_globallogic_score::_getPlayerScore( self ) - scoreSub );
				}
				
				level thread playKillBattleChatter( attacker, sWeapon, self );
				
				if ( level.teamBased )
				{
					//check if assist points should be awarded
					awardAssists = true;
				}
			}
			
			pixendevent(); //"PlayerKilled attacker" 
		}
	}
	else if ( isDefined( attacker ) && ( attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" ) )
	{
		doKillcam = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackteam = "world";
		
		thread maps\mp\_scoreevents::processScoreEvent( "suicide", self );
		self maps\mp\gametypes\_globallogic_score::incPersStat( "suicides", 1 );
		self.suicides = self  maps\mp\gametypes\_globallogic_score::getPersStat( "suicides" );

		//Check for player death related battlechatter
		thread maps\mp\gametypes\_battlechatter_mp::onPlayerSuicideOrTeamKill( self, "suicide" );	//Play suicide battlechatter

		//check if assist points should be awarded
		awardAssists = true;

	}
	else
	{
		doKillcam = false;
		
		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackteam = "world";

		// we may have a killcam on an world entity like the rocket in cosmodrome
		if ( IsDefined( eInflictor ) && IsDefined( eInflictor.killCamEnt ) )
		{
			doKillcam = true;
			lpattacknum = self getEntityNumber();
		}

		// even if the attacker isn't a player, it might be on a team
		if ( isDefined( attacker ) && isDefined( attacker.team ) && ( isdefined( level.teams[attacker.team] ) ) )
		{
			if ( attacker.team != self.team ) 
			{
				if ( level.teamBased )
					maps\mp\gametypes\_globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
			}
		}
		//check if assist points should be awarded
		awardAssists = true;
		
	}	
	
	if( sWeapon == "straferun_gun_mp" || sWeapon == "straferun_rockets_mp")
	{
		attacker maps\mp\killstreaks\_straferun::addStraferunKill();
	}
	
	if( SessionModeIsZombiesGame() )
	{
		awardAssists = false;
	}
	
	//award assist points if needed
	if( awardAssists )
	{
		pixbeginevent( "PlayerKilled assists" );
					
		if ( isdefined( self.attackers ) )
		{
			for ( j = 0; j < self.attackers.size; j++ )
			{
				player = self.attackers[j];
				
				if ( !isDefined( player ) )
					continue;
				
				if ( player == attacker )
					continue;
					
				if ( player.team != lpattackteam )
					continue;
				
				damage_done = self.attackerDamage[player.clientId].damage;
				player thread maps\mp\gametypes\_globallogic_score::processAssist( self, damage_done, self.attackerDamage[player.clientId].weapon );
			}
		}
		
		if ( level.teamBased )
		{
			self maps\mp\gametypes\_globallogic_score::processKillstreakAssists( attacker, eInflictor, sWeapon );
		}
		
		if ( isDefined( self.lastAttackedShieldPlayer ) && isDefined( self.lastAttackedShieldTime ) && self.lastAttackedShieldPlayer != attacker )
		{
			if ( gettime() - self.lastAttackedShieldTime < 4000 )
			{
				self.lastAttackedShieldPlayer thread maps\mp\gametypes\_globallogic_score::processShieldAssist( self );
			}
		}

		pixendevent(); //"END: PlayerKilled assists" 
	}

	pixbeginevent( "PlayerKilled post constants" );

	self.lastAttacker = attacker;
	self.lastDeathPos = self.origin;

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker != self && (!level.teambased || attacker.team != self.team) )
	{
		self thread maps\mp\_challenges::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc, attackerStance );
	}
	else
	{

		self notify("playerKilledChallengesProcessed");
	}

	if ( isdefined ( self.attackers ))
		self.attackers = [];
	if( isPlayer( attacker ) )
	{
		if( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
		{
			killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( sWeapon );
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d killstreak %s",
			           gettime(), getplayerspawnid( attacker ), sWeapon, lpattackorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1, killstreak );
		}
		else
		{
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d",
			           	gettime(), getplayerspawnid( attacker ), sWeapon, lpattackorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1 );
		}
	}
	else
	{
		bbPrint( "mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d",
			           gettime(), sWeapon, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1 );
	}

	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );
	attackerString = "none";
	if ( isPlayer( attacker ) ) // attacker can be the worldspawn if it's not a player
		attackerString = attacker getXuid() + "(" + lpattackname + ")";
	self logstring( "d " + sMeansOfDeath + "(" + sWeapon + ") a:" + attackerString + " d:" + iDamage + " l:" + sHitLoc + " @ " + int( self.origin[0] ) + " " + int( self.origin[1] ) + " " + int( self.origin[2] ) );

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();

	killcamentity = self getKillcamEntity( attacker, eInflictor, sWeapon );
	killcamentityindex = -1;
	killcamentitystarttime = 0;

	if ( isDefined( killcamentity ) )
	{
		killcamentityindex = killcamentity getEntityNumber(); // must do this before any waiting lest the entity be deleted
		if ( isdefined( killcamentity.startTime ) )
		{
			killcamentitystarttime = killcamentity.startTime;
		}
		else
		{
			killcamentitystarttime = killcamentity.birthtime;
		}
		if ( !isdefined( killcamentitystarttime ) )
			killcamentitystarttime = 0;
	}

	// no killcam if the player is still involved with a killstreak
	if ( isdefined(self.killstreak_waitamount) && self.killstreak_waitamount > 0  )
		doKillcam = false;

	self maps\mp\gametypes\_weapons::detachCarryObjectModel();
	
	died_in_vehicle= false;
	if (IsDefined(self.diedOnVehicle))
	{
		died_in_vehicle = self.diedOnVehicle;	// only works when vehicle blows up
	}
	pixendevent(); //"END: PlayerKilled post constants" 

	pixbeginevent( "PlayerKilled body and gibbing" );
	if ( !died_in_vehicle )
	{
		vAttackerOrigin = undefined;
		if ( isdefined( attacker ) )
			vAttackerOrigin = attacker.origin;
		
		ragdoll_now = false;
		if( IsDefined(self.usingvehicle) && self.usingvehicle && IsDefined(self.vehicleposition) && self.vehicleposition == 1 )
			ragdoll_now = true;
		
		body = self clonePlayer( deathAnimDuration );
		self createDeadBody( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_now, body );
	}
	pixendevent();// "END: PlayerKilled body and gibbing" 

	thread maps\mp\gametypes\_globallogic_spawn::spawnQueuedClient( self.team, attacker );
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	for ( iCB = 0; iCB < level.onPlayerKilledExtraUnthreadedCBs.size; iCB++ )
	{
		self [[ level.onPlayerKilledExtraUnthreadedCBs[ iCB ] ]](
			eInflictor,
			attacker,
			iDamage,
			sMeansOfDeath,
			sWeapon,
			vDir,
			sHitLoc,
			psOffsetTime,
			deathAnimDuration );
	}	
	
	self.wantSafeSpawn = false;
	perks = [];
	// perks = maps\mp\gametypes\_globallogic::getPerks( attacker );
	killstreaks = maps\mp\gametypes\_globallogic::getKillstreaks( attacker );

	if( !isdefined( self.killstreak_waitamount ) )
	{
		// start the prediction now so the client gets updates while waiting to spawn	
		self thread [[level.spawnPlayerPrediction]]();
	}
	
	profilelog_endtiming( 7, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
	
	// let the player watch themselves die
	wait ( 0.25 );

	//check if killed by a sniper
	weaponClass = getWeaponClass( sWeapon );
	if ( weaponClass == "weapon_sniper" )
	{
		self thread maps\mp\gametypes\_battlechatter_mp::KilledBySniper( attacker );
	}
	else
	{
		self thread maps\mp\gametypes\_battlechatter_mp::PlayerKilled( attacker );
	}	
	self.cancelKillcam = false;
	self thread maps\mp\gametypes\_killcam::cancelKillCamOnUse();
	
	defaultPlayerDeathWatchTime = 1.75;
	if ( isdefined ( level.overridePlayerDeathWatchTimer ) ) 
	{
		defaultPlayerDeathWatchTime = [[level.overridePlayerDeathWatchTimer]]( defaultPlayerDeathWatchTime );
	}
	
	maps\mp\gametypes\_globallogic_utils::waitForTimeOrNotifies( defaultPlayerDeathWatchTime );

	self notify ( "death_delay_finished" );

/#
	if ( GetDvarint( "scr_forcekillcam" ) != 0 )
	{
		doKillcam = true;

		if ( lpattacknum < 0 )
			lpattacknum = self getEntityNumber();
	}
#/

	if ( game["state"] != "playing" )
	{
		// if no longer playing then this was probably the kill that ended the round
		// store off the killcam info
		level thread maps\mp\gametypes\_killcam::startFinalKillcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, sWeapon, self.deathTime, deathTimeOffset, psOffsetTime, perks, killstreaks, attacker );
		return;
	}
	
	self.respawnTimerStartTime = gettime();
	
	if ( !self.cancelKillcam && doKillcam && level.killcam )
	{
		livesLeft = !(level.numLives && !self.pers["lives"]);
		timeUntilSpawn =  maps\mp\gametypes\_globallogic_spawn::TimeUntilSpawn( true );
		willRespawnImmediately = livesLeft && (timeUntilSpawn <= 0) && !level.playerQueuedRespawn;
			
		self maps\mp\gametypes\_killcam::killcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, sWeapon, self.deathTime, deathTimeOffset, psOffsetTime, willRespawnImmediately, maps\mp\gametypes\_globallogic_utils::timeUntilRoundEnd(), perks, killstreaks, attacker );
	}
	
	if ( game["state"] != "playing" )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamtargetentity = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		return;
	}
	
	WaitTillKillStreakDone();

	// class may be undefined if we have changed teams
	if ( maps\mp\gametypes\_globallogic_utils::isValidClass( self.class ) )
	{
		timePassed = undefined;
		
		if ( isdefined( self.respawnTimerStartTime ) )
		{
			timePassed = (gettime() - self.respawnTimerStartTime) / 1000;
		}
			
		self thread [[level.spawnClient]]( timePassed );
		self.respawnTimerStartTime = undefined;
	}
}

updateGlobalBotKilledCounter()
{
	if ( isDefined( self.pers["isBot"] ) )
	{
		level.globalLarrysKilled++;
	}
}


WaitTillKillStreakDone()
{
	if( isdefined( self.killstreak_waitamount ) )
	{
		starttime = gettime();
		waitTime = self.killstreak_waitamount * 1000;
		
		while( (gettime() < (starttime+waitTime)) && isdefined( self.killstreak_waitamount ) )
		{
			wait( 0.1 );
		}
		
		//Plus a small amount so we can see our dead body
		wait( 2.0 );
	
		self.killstreak_waitamount = undefined;
	}
}

TeamKillKick()
{
	self  maps\mp\gametypes\_globallogic_score::incPersStat( "sessionbans", 1 );			
	
	self endon("disconnect");
	waittillframeend;
	
	//for test purposes lets lock them out of certain game type for 2mins

	playlistbanquantum = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillerplaylistbanquantum" );
	playlistbanpenalty = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillerplaylistbanpenalty" );
	if ( playlistbanquantum > 0 && playlistbanpenalty > 0 )
	{	
		timeplayedtotal = self GetDStat( "playerstatslist", "time_played_total", "StatValue" );
		minutesplayed = timeplayedtotal / 60;
		
		freebees = 2;
		
		banallowance = int( floor(minutesplayed / playlistbanquantum) ) + freebees;
		
		if ( self.sessionbans > banallowance )
		{
			self SetDStat( "playerstatslist", "gametypeban", "StatValue", timeplayedtotal + (playlistbanpenalty * 60) ); 
		}
	}

	if ( self is_bot() )
	{
		level notify( "bot_kicked", self.team );
	}
	
	ban( self getentitynumber() );
	maps\mp\gametypes\_globallogic_audio::leaderDialog( "kicked" );		
}

TeamKillDelay()
{
	teamkills = self.pers["teamkills_nostats"];
	if ( level.minimumAllowedTeamKills < 0 || teamkills <= level.minimumAllowedTeamKills )
		return 0;

	exceeded = (teamkills - level.minimumAllowedTeamKills);
	return level.teamKillSpawnDelay * exceeded;
}


ShouldTeamKillKick(teamKillDelay)
{
	if ( teamKillDelay && ( level.minimumAllowedTeamKills >= 0 ) )
	{
		// if its more then 5 seconds into the match and we have a delay then just kick them
		if ( maps\mp\gametypes\_globallogic_utils::getTimePassed() >= 5000 )
		{
			return true;
		}
		
		// if its under 5 seconds into the match only kick them if they have killed more then one players so far
		if ( self.pers["teamkills_nostats"] > 1  )
		{
			return true;
		}
	}
	
	return false;
}

reduceTeamKillsOverTime()
{
	timePerOneTeamkillReduction = 20.0;
	reductionPerSecond = 1.0 / timePerOneTeamkillReduction;
	
	while(1)
	{
		if ( isAlive( self ) )
		{
			self.pers["teamkills_nostats"] -= reductionPerSecond;
			if ( self.pers["teamkills_nostats"] < level.minimumAllowedTeamKills )
			{
				self.pers["teamkills_nostats"] = level.minimumAllowedTeamKills;
				break;
			}
		}
		wait 1;
	}
}


IgnoreTeamKills( sWeapon, sMeansOfDeath )
{
	if( SessionModeIsZombiesGame() )
		return true;	
		
	if ( sMeansOfDeath == "MOD_MELEE" )
		return false;
		
	if ( sWeapon == "briefcase_bomb_mp" )
		return true;
		
	if ( sWeapon == "supplydrop_mp" )
		return true;
	
	return false;	
}


Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	//maps\mp\_laststand::playerlaststand(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );	
}


damageShellshockAndRumble( eAttacker, eInflictor, sWeapon, sMeansOfDeath, iDamage )
{
	self thread maps\mp\gametypes\_weapons::onWeaponDamage( eAttacker, eInflictor, sWeapon, sMeansOfDeath, iDamage );
	self PlayRumbleOnEntity( "damage_heavy" );
}


createDeadBody( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body )
{
	if ( sMeansOfDeath == "MOD_HIT_BY_OBJECT" && self GetStance() == "prone" )
	{
		self.body = body;
		if ( !isDefined( self.switching_teams ) )
			thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.team, 5.0 );

		return;
	}

	if ( IsDefined( level.ragdoll_override ) && self [[level.ragdoll_override]]() )
	{
		return;
	}

	if ( ragdoll_jib || self isOnLadder() || self isMantling() || sMeansOfDeath == "MOD_CRUSH" || sMeansOfDeath == "MOD_HIT_BY_OBJECT" )
		body startRagDoll();

	if ( !self IsOnGround() )
	{
		if ( GetDvarint( "scr_disable_air_death_ragdoll" ) == 0 )
		{
			body startRagDoll();
		}
	}

	if ( self is_explosive_ragdoll( sWeapon, eInflictor ) )
	{
		body start_explosive_ragdoll( vDir, sWeapon );
	}

	thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );

	if( sMeansOfDeath == "MOD_BURNED" || isdefined( self.burning ) )
	{
		body maps\mp\_burnplayer::burnedToDeath();		
	}	
	if ( sMeansOfDeath == "MOD_CRUSH" )
	{
		body maps\mp\gametypes\_globallogic_vehicle::vehicleCrush();
	}
	
	self.body = body;
	if ( !isDefined( self.switching_teams ) )
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.team, 5.0 );
}

is_explosive_ragdoll( weapon, inflictor )
{
	if ( !IsDefined( weapon ) )
	{
		return false;
	}

	// destructible explosives
	if ( weapon == "destructible_car_mp" || weapon == "explodable_barrel_mp" )
	{
		return true;
	}

	// special explosive weapons
	if ( weapon == "sticky_grenade_mp" || weapon == "explosive_bolt_mp" )
	{
		if ( IsDefined( inflictor ) && IsDefined( inflictor.stuckToPlayer ) )
		{
			if ( inflictor.stuckToPlayer == self )
			{
				return true;
			}
		}
	}

	return false;
}

start_explosive_ragdoll( dir, weapon )
{
	if ( !IsDefined( self ) )
	{
		return;
	}

	x = RandomIntRange( 50, 100 );
	y = RandomIntRange( 50, 100 );
	z = RandomIntRange( 10, 20 );

	if ( IsDefined( weapon ) && ( weapon == "sticky_grenade_mp" || weapon == "explosive_bolt_mp" ) )
	{
		if ( IsDefined( dir ) && LengthSquared( dir ) > 0 )
		{
			x = dir[0] * x;
			y = dir[1] * y;
		}
	}
	else
	{
		if ( cointoss() )
		{
			x = x * -1;
		}
		if ( cointoss() )
		{
			y = y * -1;
		}
	}

	self StartRagdoll();
	self LaunchRagdoll( ( x, y, z ) );
}


notifyConnecting()
{
	waittillframeend;

	if( isDefined( self ) )
		level notify( "connecting", self );
}


delayStartRagdoll( ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath )
{
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}
	
	if ( level.oldschool )
	{
		if ( !isDefined( vDir ) )
			vDir = (0,0,0);
		
		explosionPos = ent.origin + ( 0, 0, maps\mp\gametypes\_globallogic_utils::getHitLocHeight( sHitLoc ) );
		explosionPos -= vDir * 20;
		//thread maps\mp\gametypes\_globallogic_utils::debugLine( ent.origin + (0,0,(explosionPos[2] - ent.origin[2])), explosionPos );
		explosionRadius = 40;
		explosionForce = .75;
		if ( sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_EXPLOSIVE" || isSubStr(sMeansOfDeath, "MOD_GRENADE") || isSubStr(sMeansOfDeath, "MOD_PROJECTILE") || sHitLoc == "head" || sHitLoc == "helmet" )
		{
			explosionForce = 2.5;
		}
		
		ent startragdoll( 1 );
		
		wait .05;
		
		if ( !isDefined( ent ) )
			return;
		
		// apply extra physics force to make the ragdoll go crazy
		physicsExplosionSphere( explosionPos, explosionRadius, explosionRadius/2, explosionForce );
		return;
	}
	
	wait( 0.2 );
	
	if ( !isDefined( ent ) )
		return;
	
	if ( ent isRagDoll() )
		return;
	
	deathAnim = ent getcorpseanim();

	startFrac = 0.35;

	if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
	{
		times = getnotetracktimes( deathAnim, "start_ragdoll" );
		if ( isDefined( times ) )
			startFrac = times[0];
	}

	waitTime = startFrac * getanimlength( deathAnim );
	wait( waitTime );

	if ( isDefined( ent ) )
	{
		ent startragdoll( 1 );
	}
}

trackAttackerDamage( eAttacker, iDamage, sMeansOfDeath, sWeapon )
{
	Assert( isPlayer( eAttacker ) );
	if ( self.attackerData.size == 0 ) 
	{
		self.firstTimeDamaged = getTime();	
	}
	if ( !isdefined( self.attackerData[eAttacker.clientid] ) )
	{
		self.attackerDamage[eAttacker.clientid] = spawnstruct();
		self.attackerDamage[eAttacker.clientid].damage = iDamage;
		self.attackerDamage[eAttacker.clientid].meansOfDeath = sMeansOfDeath;
		self.attackerDamage[eAttacker.clientid].weapon = sWeapon;
		self.attackerDamage[eAttacker.clientid].time = getTime();

		self.attackers[ self.attackers.size ] = eAttacker;

		// we keep an array of attackers by their client ID so we can easily tell
		// if they're already one of the existing attackers in the above if().
		// we store in this array data that is useful for other things, like challenges
		self.attackerData[eAttacker.clientid] = false;
	}
	else
	{
		self.attackerDamage[eAttacker.clientid].damage += iDamage;
		self.attackerDamage[eAttacker.clientid].meansOfDeath = sMeansOfDeath;
		self.attackerDamage[eAttacker.clientid].weapon = sWeapon;
		if ( !isdefined( self.attackerDamage[eAttacker.clientid].time ) )
			self.attackerDamage[eAttacker.clientid].time = getTime();
	}

	self.attackerDamage[eAttacker.clientid].lasttimedamaged = getTime();
	if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( sWeapon ) )
		self.attackerData[eAttacker.clientid] = true;
}

giveInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, sWeapon )
{
	if ( !isDefined( eInflictor ) )
		return;
		
	if ( !isDefined( eInflictor.owner ) )
		return;
		
	if ( !IsDefined( eInflictor.ownerGetsAssist ) )
		return;
		
	if ( !eInflictor.ownerGetsAssist )
		return;
		
	Assert( isPlayer( eInflictor.owner ) );
	
	self trackAttackerDamage( eInflictor.owner, iDamage, sMeansOfDeath, sWeapon );
}

updateMeansOfDeath( sWeapon, sMeansOfDeath )
{
	// we do not want the melee icon to show up for dog attacks
	switch(sWeapon)
	{
	case "crossbow_mp":
	case "knife_ballistic_mp":
		{
			if ( ( sMeansOfDeath != "MOD_HEAD_SHOT" ) && ( sMeansOfDeath != "MOD_MELEE" ) )
			{
				sMeansOfDeath = "MOD_PISTOL_BULLET";
			}
		}
		break;
	case "dog_bite_mp":
		sMeansOfDeath = "MOD_PISTOL_BULLET";
		break;
	case "destructible_car_mp":
		sMeansOfDeath = "MOD_EXPLOSIVE";
		break;
	case "explodable_barrel_mp":
		sMeansOfDeath = "MOD_EXPLOSIVE";
		break;
	}

	return sMeansOfDeath;
}

updateAttacker( attacker )
{
	if( isai(attacker) && isDefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( !level.teambased || attacker.script_owner.team != self.team )
			attacker = attacker.script_owner;
	}
	
	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
	{
		attacker notify("killed",self);

		attacker = attacker.owner;
	}

	if( isai(attacker) )
		attacker notify("killed",self);
		
	if ( ( isdefined ( self.capturingLastFlag ) ) && ( self.capturingLastFlag == true ) )
	{
		attacker.lastCapKiller = true;
	}
	
	return attacker;
}

updateInflictor( eInflictor )
{
	if( IsDefined( eInflictor ) && eInflictor.classname == "script_vehicle" )
	{
		eInflictor notify("killed",self);
		
		if ( isDefined( eInflictor.bda ) )
		{
			eInflictor.bda++;
		}
	}
	
	return eInflictor;
}

updateWeapon( eInflictor, sWeapon )
{
	// explosive barrel/car detection
	if ( sWeapon == "none" && isDefined( eInflictor ) )
	{
		if ( isDefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
			sWeapon = "explodable_barrel_mp";
		else if ( isDefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
			sWeapon = "destructible_car_mp";
	}
	
	return sWeapon;
}

getClosestKillcamEntity( attacker, killCamEntities, depth )
{
	if ( !isdefined( depth ) )
		depth = 0;
		
	closestKillcamEnt = undefined;
	closestKillcamEntIndex = undefined;
	closestKillcamEntDist = undefined;
	origin = undefined;
	
	foreach( killcamEntIndex, killcamEnt in killCamEntities )
	{
		if ( killcamEnt == attacker )
			continue;
		
		origin = killcamEnt.origin;
		if ( IsDefined( killcamEnt.offsetPoint ) )
			origin += killcamEnt.offsetPoint;

		dist = DistanceSquared( self.origin, origin );

		if ( !IsDefined( closestKillcamEnt ) || dist < closestKillcamEntDist )
		{
			closestKillcamEnt = killcamEnt;
			closestKillcamEntDist = dist;
			closestKillcamEntIndex = killcamEntIndex;
		}
	}
	
	// check to see if the player is visible at time of death
	if ( depth < 3 && isdefined( closestKillcamEnt ) )
	{
		if ( !BulletTracePassed( closestKillcamEnt.origin, self.origin, false, self ) )
		{
			killCamEntities[closestKillcamEntIndex] = undefined;
			
			betterKillcamEnt = getClosestKillcamEntity( attacker, killCamEntities, depth + 1 );
			
			if ( isdefined( betterKillcamEnt ) )
			{
				closestKillcamEnt = betterKillcamEnt;
			}
		}
	}

	return closestKillcamEnt;
}

getKillcamEntity( attacker, eInflictor, sWeapon )
{
	if ( !isDefined( eInflictor ) )
		return undefined;

	if ( eInflictor == attacker )
	{
		if( !IsDefined( eInflictor.isMagicBullet ) )
			return undefined;
		if( IsDefined( eInflictor.isMagicBullet ) && !eInflictor.isMagicBullet )
			return undefined;
	}
	else if ( isdefined( level.levelSpecificKillcam ) )
	{
		levelSpecificKillcamEnt = self [[level.levelSpecificKillcam]]();
		if ( isdefined( levelSpecificKillcamEnt ) )
			return levelSpecificKillcamEnt;
	}
	
	if ( sWeapon == "m220_tow_mp" )
		return undefined;
	
	if ( isDefined(eInflictor.killCamEnt) )
	{
		// this is the case with the player helis
		if ( eInflictor.killCamEnt == attacker )
			return undefined;
			
		return eInflictor.killCamEnt;
	}
	else if ( isDefined(eInflictor.killCamEntities) )
	{
		return getClosestKillcamEntity( attacker, eInflictor.killCamEntities );
	}
	
	if ( isDefined( eInflictor.script_gameobjectname ) && eInflictor.script_gameobjectname == "bombzone" )
		return eInflictor.killCamEnt;

	return eInflictor;
}
	
playKillBattleChatter( attacker, sWeapon, victim )
{
	if( IsPlayer( attacker ) )
	{
		if ( !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
		{
			level thread maps\mp\gametypes\_battlechatter_mp::sayKillBattleChatter( attacker, sWeapon, victim );
		}
	}
}

