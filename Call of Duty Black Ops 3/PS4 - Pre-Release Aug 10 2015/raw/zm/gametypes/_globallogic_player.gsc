#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_damagefeedback;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hostmigration;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_spectating;
#using scripts\zm\gametypes\_weapons;

#using scripts\zm\_challenges;
#using scripts\zm\_util;
#using scripts\zm\_zm_stats;

#namespace globallogic_player;

function freezePlayerForRoundEnd()
{
	self util::clearLowerMessage();
	
	self closeInGameMenu();
	
	self util::freeze_player_controls( true );
}

function Callback_PlayerConnect()
{
	thread notifyConnecting();

	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	
	if( isdefined( level.reset_clientdvars ) )
		self [[level.reset_clientdvars]]();

	waittillframeend;
	self.statusicon = "";

	self.guid = self getGuid();

	profilelog_begintiming( 4, "ship" );

	level notify( "connected", self );
	
	if ( self IsHost() )
		self thread globallogic::listenForGameEnd();

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
	{
		iPrintLn(&"MP_CONNECTED", self);
	}

	if( !isdefined( self.pers["score"] ) )
	{
		self thread zm_stats::adjustRecentStats();
	}
	
	// track match and hosting stats once per match
	if( GameModeIsMode( 0 ) && !isdefined( self.pers["matchesPlayedStatsTracked"] ) )
	{
		gameMode = util::GetCurrentGameMode();
		self globallogic::IncrementMatchCompletionStat( gameMode, "played", "started" );
				
		if ( !isdefined( self.pers["matchesHostedStatsTracked"] ) && self IsLocalToHost() )
		{
			self globallogic::IncrementMatchCompletionStat( gameMode, "hosted", "started" );
			self.pers["matchesHostedStatsTracked"] = true;
		}
		
		self.pers["matchesPlayedStatsTracked"] = true;
		self thread zm_stats::uploadStatsSoon();
	}

	//self _gamerep::gameRepPlayerConnected();

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	bbPrint( "global_joins", "name %s client %s", self.name, lpselfnum );
	
	if( !SessionModeIsZombiesGame() ) // it will be set after intro screen is faded out for zombie
	{
		self setClientUIVisibilityFlag( "hud_visible", 1 );
		self setClientUIVisibilityFlag( "weapon_hud_visible", 1 );
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

	//makeDvarServerInfo( "cg_drawTalk", 1 );
	
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
	
		self  globallogic_score::initPersStat( "score" );
		if ( level.resetPlayerScoreEveryRound )
		{
			self.pers["score"] = 0;
		}
		self.score = self.pers["score"];

		self  globallogic_score::initPersStat( "momentum", false );
		self.momentum = self  globallogic_score::getPersStat( "momentum" );

		self  globallogic_score::initPersStat( "suicides" );
		self.suicides = self  globallogic_score::getPersStat( "suicides" );

		self  globallogic_score::initPersStat( "headshots" );
		self.headshots = self  globallogic_score::getPersStat( "headshots" );
	
		self  globallogic_score::initPersStat( "challenges" );
		self.challenges = self  globallogic_score::getPersStat( "challenges" );	

		self  globallogic_score::initPersStat( "kills" );
		self.kills = self  globallogic_score::getPersStat( "kills" );

		self  globallogic_score::initPersStat( "deaths" );
		self.deaths = self  globallogic_score::getPersStat( "deaths" );
	
		self  globallogic_score::initPersStat( "assists" );
		self.assists = self  globallogic_score::getPersStat( "assists" );
	
		self  globallogic_score::initPersStat( "defends", false );
		self.defends = self  globallogic_score::getPersStat( "defends" );

		self  globallogic_score::initPersStat( "offends", false );
		self.offends = self  globallogic_score::getPersStat( "offends" );

		self  globallogic_score::initPersStat( "plants", false );
		self.plants = self  globallogic_score::getPersStat( "plants" );

		self  globallogic_score::initPersStat( "defuses", false );
		self.defuses = self  globallogic_score::getPersStat( "defuses" );

		self  globallogic_score::initPersStat( "returns", false );
		self.returns = self  globallogic_score::getPersStat( "returns" );

		self  globallogic_score::initPersStat( "captures", false );
		self.captures = self  globallogic_score::getPersStat( "captures" );

		self  globallogic_score::initPersStat( "destructions", false );
		self.destructions = self  globallogic_score::getPersStat( "destructions" );
	
		self  globallogic_score::initPersStat( "disables", false );
		self.disables = self  globallogic_score::getPersStat( "disables" );
		
		self  globallogic_score::initPersStat( "escorts", false );
		self.escorts = self  globallogic_score::getPersStat( "escorts" );
		
		self  globallogic_score::initPersStat( "carries", false );
		self.destructions = self  globallogic_score::getPersStat( "carries" );

		self  globallogic_score::initPersStat( "throws", false );
		self.destructions = self  globallogic_score::getPersStat( "throws" );	
		
		self  globallogic_score::initPersStat( "backstabs", false );
		self.backstabs = self  globallogic_score::getPersStat( "backstabs" );
	
		self  globallogic_score::initPersStat( "longshots", false );
		self.longshots = self  globallogic_score::getPersStat( "longshots" );
	
		self  globallogic_score::initPersStat( "survived", false );
		self.survived = self  globallogic_score::getPersStat( "survived" );
	
		self  globallogic_score::initPersStat( "stabs", false );
		self.stabs = self  globallogic_score::getPersStat( "stabs" );
	
		self  globallogic_score::initPersStat( "tomahawks", false );
		self.tomahawks = self  globallogic_score::getPersStat( "tomahawks" );
	
		self  globallogic_score::initPersStat( "humiliated", false );
		self.humiliated = self  globallogic_score::getPersStat( "humiliated" );
	
		self  globallogic_score::initPersStat( "x2score", false );
		self.x2score = self  globallogic_score::getPersStat( "x2score" );

		self  globallogic_score::initPersStat( "agrkills", false );
		self.x2score = self  globallogic_score::getPersStat( "agrkills" );

		self  globallogic_score::initPersStat( "hacks", false );
		self.x2score = self  globallogic_score::getPersStat( "hacks" );
	
		self  globallogic_score::initPersStat( "sessionbans", false );
		self.sessionbans = self  globallogic_score::getPersStat( "sessionbans" );
		self  globallogic_score::initPersStat( "gametypeban", false );
		self  globallogic_score::initPersStat( "time_played_total", false );
		self  globallogic_score::initPersStat( "time_played_alive", false );
	
		self  globallogic_score::initPersStat( "teamkills", false );
		self  globallogic_score::initPersStat( "teamkills_nostats", false );
		self.teamKillPunish = false;
		if ( level.minimumAllowedTeamKills >= 0 && self.pers["teamkills_nostats"] > level.minimumAllowedTeamKills )
			self thread reduceTeamKillsOverTime();
	}
			
	self.killedPlayersCurrent = [];

	if( !isdefined( self.pers["best_kill_streak"] ) )
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
	if( !isdefined( self.pers["music"] ) )
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
	
	if ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks && !isdefined( self.pers["killstreak_quantity"] ) )
		self.pers["killstreak_quantity"] = [];

	if ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks && !isdefined( self.pers["held_killstreak_ammo_count"] ) )
		self.pers["held_killstreak_ammo_count"] = [];

	self.lastKillTime = 0;
	
	self.cur_death_streak = 0;
	self disabledeathstreak();
	self.death_streak = 0;
	self.kill_streak = 0;
	self.gametype_kill_streak = 0;
	self.spawnQueueIndex = -1;
	self.deathTime = 0;
	
	/*if ( level.onlineGame )
	{
		self.death_streak = self getDStat( "HighestStats",  "death_streak" );
		self.kill_streak = self getDStat( "HighestStats", "kill_streak" );
		self.gametype_kill_streak = self _persistence::statGetWithGameType( "kill_streak" );
	}*/

	self.lastGrenadeSuicideTime = -1;

	self.teamkillsThisRound = 0;
	
	if ( !isdefined( level.livesDoNotReset ) || !level.livesDoNotReset || !isdefined( self.pers["lives"] ) )
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
	
	level.players[level.players.size] = self;
	
	if( level.splitscreen )
		SetDvar( "splitscreen_playerNum", level.players.size );
	// removed underscore for debug CDC
	//globallogic_audio::set_music_on_team( "UNDERSCORE", "both", true );;
	// When joining a game in progress, if the game is at the post game state (scoreboard) the connecting player should spawn into intermission
	if ( game["state"] == "postgame" )
	{
		self.pers["needteam"] = 1;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionteam = "spectator";
	  self setClientUIVisibilityFlag( "hud_visible", 0 );
		
		self [[level.spawnIntermission]]();
		self closeInGameMenu();
		profilelog_endtiming( 4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
		return;
	}

	// count losses for encounter game.
	if ( level.scr_zm_ui_gametype_group == "zencounter" )
	{
		self zm_stats::increment_client_stat( "losses" );
		self UpdateStatRatio( "wlratio", "wins", "losses" );
		if ( GameModeIsMode( 0 ) )
			self zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "losses", 1 );		
	}
	else if ( level.scr_zm_ui_gametype_group == "zsurvival" )
	{
		if ( ( isdefined( level.should_use_cia ) && level.should_use_cia ) )
		{
			self zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "losses", 1 );
		}
	}

	// don't redo winstreak save to pers array for each round of round based games.
	/*if ( !isdefined( self.pers["winstreakAlreadyCleared"] ) )
	{
			self  globallogic_score::backupAndClearWinStreaks();
			self.pers["winstreakAlreadyCleared"] = true;
	}
		
	if( self istestclient() )
	{
		self.pers[ "isBot" ] = true;
	}*/
	
	/*if ( level.rankedMatch || level.leagueMatch )
	{
		self _persistence::setAfterActionReportStat( "demoFileID", "0" );
	}*/
	
	level endon( "game_ended" );

	if ( isdefined( level.hostMigrationTimer ) )
		self thread hostmigration::hostMigrationTimerThink();
	
	if ( level.oldschool )
	{
		self.pers["class"] = undefined;
		self.curClass = self.pers["class"];
	}

	if ( isdefined( self.pers["team"] ) )
		self.team = self.pers["team"];

	if ( isdefined( self.pers["class"] ) )
		self.curClass = self.pers["class"];
		
	if ( !isdefined( self.pers["team"] ) || isdefined( self.pers["needteam"] ) )
	{
		// Don't set .sessionteam until we've gotten the assigned team from code,
		// because it overrides the assigned team.
		self.pers["needteam"] = undefined;
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self.sessionstate = "dead";
		
		self globallogic_ui::updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		if ( level.rankedMatch )
		{
			[[level.autoassign]]( false );
			
			//self thread globallogic_spawn::forceSpawn();
			self thread globallogic_spawn::kickIfDontSpawn();
		}
		else
		{
			[[level.autoassign]]( false );
		}
		
		if ( self.pers["team"] == "spectator" )
		{
			self.sessionteam = "spectator";
			self thread spectate_player_watcher();
		}
		
		if ( level.teamBased )
		{
			// set team and spectate permissions so the map shows waypoint info on connect
			self.sessionteam = self.pers["team"];
			if ( !isAlive( self ) )
				self.statusicon = "hud_status_dead";
			self thread spectating::setSpectatePermissions();
		}
	}
	else if ( self.pers["team"] == "spectator" )
	{
		self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
		[[level.spawnSpectator]]();
		self.sessionteam = "spectator";
		self.sessionstate = "spectator";
		self thread spectate_player_watcher();
	}
	else
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";

		self globallogic_ui::updateObjectiveText();
		
		[[level.spawnSpectator]]();
		
		if ( globallogic_utils::isValidClass( self.pers["class"] ) )
		{
			self thread [[level.spawnClient]]();			
		}
		else
		{
			self globallogic_ui::showMainMenuForTeam();
		}
		
		self thread spectating::setSpectatePermissions();
	}

	if ( self.sessionteam != "spectator" )
	{
		self thread spawning::onSpawnPlayer_Unified(true);
	}
	
	profilelog_endtiming( 4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

function spectate_player_watcher()
{
	self endon( "disconnect" );
	
	self.watchingActiveClient = true;
	self.waitingForPlayersText = undefined;

	while ( 1 )
	{
		if ( self.pers["team"] != "spectator" || level.gameEnded )
		{
			self hud_message::clearShoutcasterWaitingMessage();
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
					self hud::showPerks( );
				}
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
					self hud_message::clearShoutcasterWaitingMessage();
					self FreezeControls( false );
					/# println(" Unfreeze controls 2"); #/

				}
				
				self.watchingActiveClient = true;
			}
			else
			{
				if ( self.watchingActiveClient ) 
				{
					[[level.onSpawnSpectator]]();
					self FreezeControls( true );
					self hud_message::setShoutcasterWaitingMessage();
				}
				
				self.watchingActiveClient = false;
			}
			
			wait( 0.5 );
		}
	}
}

function Callback_PlayerMigrated()
{
/#	println( "Player " + self.name + " finished migrating at time " + gettime() );	#/
	
	if ( isdefined( self.connected ) && self.connected )
	{
		self globallogic_ui::updateObjectiveText();
//		self globallogic_ui::updateObjectiveText();
//		self updateMainMenu();

//		if ( level.teambased )
//			self updateScores();
	}
	
	self thread inform_clientvm_of_migration();
	
	level.hostMigrationReturnedPlayerCount++;
	if ( level.hostMigrationReturnedPlayerCount >= level.players.size * 2 / 3 )
	{
	/#	println( "2/3 of players have finished migrating" );	#/
		level notify( "hostmigration_enoughplayers" );
	}
}

function inform_clientvm_of_migration()
{
	self endon("disconnect");
	wait 1.0;
	
	self util::clientNotify("hmo");
}

function Callback_PlayerDisconnect()
{
	profilelog_begintiming( 5, "ship" );

	if ( game["state"] != "postgame" && !level.gameEnded )
	{
		gameLength = globallogic::getGameLength();
		self globallogic::bbPlayerMatchEnd( gameLength, "MP_PLAYER_DISCONNECT", 0 );
	}

	ArrayRemoveValue( level.players, self );

	if ( level.splitscreen )
	{
		players = level.players;
		
		if ( players.size <= 1 )
			level thread globallogic::forceEnd();
			
		// passing number of players to menus in splitscreen to display leave or end game option
		SetDvar( "splitscreen_playerNum", players.size );
	}

	if ( isdefined( self.score ) && isdefined( self.pers["team"] ) )
	{
		/#print( "team: score " + self.pers["team"] + ":" + self.score );#/
		level.dropTeam += 1;
	}
	
	[[level.onPlayerDisconnect]]();
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	
	//self _gamerep::gameRepPlayerDisconnected();
	
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
		if ( isdefined( level.players[entry].pers["killed_players"][self.name] ) )
			level.players[entry].pers["killed_players"][self.name] = undefined;

		if ( isdefined( level.players[entry].killedPlayersCurrent[self.name] ) )
			level.players[entry].killedPlayersCurrent[self.name] = undefined;

		if ( isdefined( level.players[entry].pers["killed_by"][self.name] ) )
			level.players[entry].pers["killed_by"][self.name] = undefined;

		if ( isdefined( level.players[entry].pers["nemesis_tracking"][self.name] ) )
			level.players[entry].pers["nemesis_tracking"][self.name] = undefined;
		
		// player that disconnected was our nemesis
		if ( level.players[entry].pers["nemesis_name"] == self.name )
		{
			level.players[entry] chooseNextBestNemesis();
		}
	}

	if ( level.gameEnded )
		self globallogic::removeDisconnectedPlayerFromPlacement();
	
	level thread globallogic::updateTeamStatus();
	
	profilelog_endtiming( 5, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

function Callback_PlayerMelee( eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit, fromBehind  )
{
	hit = true;
	
	if ( level.teamBased && self.team == eAttacker.team )
	{
		if ( level.friendlyfire == 0 ) // no one takes damage
		{
			hit = false;
		}
	}
	
	self finishMeleeHit( eAttacker, weapon, vOrigin, vDir, boneIndex, shieldHit, hit, fromBehind );
}

function chooseNextBestNemesis()
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

function custom_gamemodes_modified_damage( victim, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc )
{
	// regular public matches should early out
	if ( level.onlinegame && !SessionModeIsPrivate() )
	{
		return iDamage;
	}
	
	if( isdefined( eAttacker) &&  isdefined( eAttacker.damageModifier ) )
	{
		iDamage *= eAttacker.damageModifier;
	}
	if ( ( sMeansOfDeath == "MOD_PISTOL_BULLET" ) || ( sMeansOfDeath == "MOD_RIFLE_BULLET" ) )
	{
		iDamage = int( iDamage * level.bulletDamageScalar );
	}
	
	return iDamage;
}

function figureOutAttacker( eAttacker )
{
	if ( isdefined(eAttacker) )
	{
		if( isai(eAttacker) && isdefined( eAttacker.script_owner ) )
		{
			team = self.team;
			
			if ( eAttacker.script_owner.team != team )
				eAttacker = eAttacker.script_owner;
		}
			
		if( eAttacker.classname == "script_vehicle" && isdefined( eAttacker.owner ) )
			eAttacker = eAttacker.owner;
		else if( eAttacker.classname == "auto_turret" && isdefined( eAttacker.owner ) )
			eAttacker = eAttacker.owner;
	}

	return eAttacker;
}

function figureOutWeapon( weapon, eInflictor )
{
	// explosive barrel/car detection
	if ( weapon == level.weaponNone && isdefined( eInflictor ) )
	{
		if ( isdefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
		{
			weapon = GetWeapon( "explodable_barrel" );
		}
		else if ( isdefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
		{
			weapon = GetWeapon( "destructible_car" );
		}
	}

	return weapon;
}


function isPlayerImmuneToKillstreak( eAttacker, weapon )
{
	if ( level.hardcoreMode )
		return false;
	
	if ( !isdefined( eAttacker ) )
		return false;
	
	if ( self != eAttacker )
		return false;
	
	return weapon.immunityForOwner;
}

function Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	profilelog_begintiming( 6, "ship" );
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( self.sessionteam == "spectator" )
		return; 
	
	if ( isdefined( self.canDoCombat ) && !self.canDoCombat )
		return;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;

	if ( isdefined( level.hostMigrationTimer ) )
		return;
	
	if ( self.scene_takedamage === false )
	{
		return;
	}

	weaponName = weapon.name;
	if ( ( weaponName == "ai_tank_drone_gun" || weaponName == "ai_tank_drone_rocket" ) && !level.hardcoreMode )
	{
		// rocket fired from AI
		if ( isdefined( eAttacker ) && eAttacker == self )
		{
			if ( isdefined( eInflictor ) && isdefined( eInflictor.from_ai ) )
			{
				return;
			}
		}
		
		// bullet weapon fired from AI
		if ( isdefined( eAttacker ) && isdefined( eAttacker.owner ) && eAttacker.owner == self )
		{
			return;
		}
	}

	if ( weapon.isEmp )
	{
		self notify( "emp_grenaded", eAttacker );
	}

/*	if ( isdefined( eAttacker ) ) 
	{
		iDamage = _class::cac_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc );
	}*/
	iDamage = custom_gamemodes_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc );
	
	iDamage = int(iDamage);
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();

	eAttacker = figureOutAttacker( eAttacker );

	pixbeginevent( "PlayerDamage flags/tweaks" );

	// Don't do knockback if the damage direction was not specified
	if( !isdefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = false;
	// Todo MGordon - Fix this stat collection
	//self thread  globallogic_score::threadedSetStatLBByName( weapon, 1, "hits by", 2 );

	// added check to notify chatter to play pain vo
	if ( self.health != self.maxhealth )
	{
		self notify( "snd_pain_player", sMeansOfDeath );
	}	

	if ( isdefined( eInflictor) && isdefined( eInflictor.script_noteworthy) && eInflictor.script_noteworthy == "ragdoll_now" )
	{
		sMeansOfDeath = "MOD_FALLING";
	}

	if ( globallogic_utils::isHeadShot( weapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer(eAttacker) )
	{
		//Turning off damage headshot sounds to avoid confusion from the killing headshot sound.
		//if (self.team != eAttacker.team)
		//{
		//	eAttacker playLocalSound( "prj_bullet_impact_headshot_helmet_nodie_2d" );	
		//}
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	if ( level.onPlayerDamage != &globallogic::blank )
	{
		modifiedDamage = [[level.onPlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
		
		if ( isdefined( modifiedDamage ) )
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
//	if ( self _vehicles::player_is_occupant_invulnerable( sMeansOfDeath ) )
//		return;

	if (isdefined (eAttacker) && isPlayer(eAttacker) && (self.team != eAttacker.team))
	{
		self.lastAttackWeapon = weapon;
	}
	
	weapon = figureOutWeapon( weapon, eInflictor );

	pixendevent(); //  "END: PlayerDamage flags/tweaks"
	
//	if( iDFlags & level.iDFLAGS_PENETRATION && isplayer ( eAttacker ) && eAttacker hasPerk( "specialty_bulletpenetration" ) )
//		self thread _battlechatter_mp::perkSpecificBattleChatter( "deepimpact", true );

	attackerIsHittingTeammate = isPlayer( eAttacker ) && ( self util::IsEnemyPlayer( eAttacker ) == false );

	if ( sHitLoc == "riotshield" )
	{
		if ( attackerIsHittingTeammate && level.friendlyfire == 0 )
		{
			return;
		}

		if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" && !attackerIsHittingTeammate )
		{
			previous_shield_damage = self.shieldDamageBlocked;
			self.shieldDamageBlocked += iDamage;

			if ( isPlayer( eAttacker ))
			{
				eAttacker.lastAttackedShieldPlayer = self;
				eAttacker.lastAttackedShieldTime = getTime();
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
			if ( isdefined( eInflictor ) && isdefined( eInflictor.stuckToPlayer ) && eInflictor.stuckToPlayer == self )
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
	/*if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		if ( isdefined( eInflictor ) && ( sMeansOfDeath == "MOD_GAS" || _class::isExplosiveDamage( sMeansOfDeath ) ) )
		{
			// protect players from spawnkill grenades, tabun and incendiary
			if ( ( eInflictor.classname == "grenade" || weaponName == "tabun_gas" )  && (self.lastSpawnTime + 3500) > getTime() && DistanceSquared( eInflictor.origin, self.lastSpawnPoint.origin ) < 250 * 250 )
			{
//				pixmarker( "END: Callback_PlayerDamage player" );
				return;
			}
			
			// protect players from their own non-player controlled killstreaks
			if ( self isPlayerImmuneToKillstreak( eAttacker, weapon ) )
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
			self.explosiveInfo["weapon"] = weapon;
			self.explosiveInfo["originalowner"] = eInflictor.originalowner;
			
			isFrag = ( weaponName == "frag_grenade" );

			if ( isdefined( eAttacker ) && eAttacker != self )
			{
				if ( isdefined( eAttacker ) && isdefined( eInflictor.owner ) && ( weaponName == "satchel_charge" || weaponName == "claymore" || weaponName == "bouncingbetty" ) )
				{
					self.explosiveInfo["originalOwnerKill"] = (eInflictor.owner == self);
					self.explosiveInfo["damageExplosiveKill"] = isdefined( eInflictor.wasDamaged );
					self.explosiveInfo["chainKill"] = isdefined( eInflictor.wasChained );
					self.explosiveInfo["wasJustPlanted"] = isdefined( eInflictor.wasJustPlanted );
					self.explosiveInfo["bulletPenetrationKill"] = isdefined( eInflictor.wasDamagedFromBulletPenetration );
					self.explosiveInfo["cookedKill"] = false;
				}
				if ( ( weaponName == "sticky_grenade" || weaponName == "explosive_bolt"  ) && isdefined( eInflictor ) && isdefined( eInflictor.stuckToPlayer ) )
				{
					self.explosiveInfo["stuckToPlayer"] = eInflictor.stuckToPlayer;
				}
				if ( weapon.isStun )
				{
					self.lastStunnedBy = eAttacker;
					self.lastStunnedTime = self.iDFlagsTime;
				}
				if ( isdefined( eAttacker.lastGrenadeSuicideTime ) && eAttacker.lastGrenadeSuicideTime >= gettime() - 50 && isFrag )
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
				self.explosiveInfo["cookedKill"] = isdefined( eInflictor.isCooked );
				self.explosiveInfo["throwbackKill"] = isdefined( eInflictor.threwBack );
			}

			if( isdefined( eAttacker ) && isPlayer( eAttacker ) && eAttacker != self )
			{
				self globallogic_score::setInflictorStat( eInflictor, eAttacker, weapon );
			}
		}

		if( sMeansOfDeath == "MOD_IMPACT" && isdefined( eAttacker ) && isPlayer( eAttacker ) && eAttacker != self )
		{
			if ( weapon != level.weaponBallisticKnife )
			{
				self globallogic_score::setInflictorStat( eInflictor, eAttacker, sWeapon );
			}

			if ( weaponName == "hatchet" && isdefined( eInflictor ) )
			{
				self.explosiveInfo["projectile_bounced"] = isdefined( eInflictor.bounced );
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
				if ( weapon.forceDamageShellshockAndRumble )
				{
					self damageShellshockAndRumble( eAttacker, eInflictor, sWeapon, sMeansOfDeath, iDamage );
				}
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
					eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
					eAttacker.friendlydamage = undefined;
				}
				else
				{
					self.lastDamageWasFromEnemy = false;
					
					self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
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
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
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
				
				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
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

			if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && allowedAssistWeapon( weapon ) )
			{				
				self trackAttackerDamage( eAttacker, iDamage, sMeansOfDeath, weapon );
			}
		
			giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon );
	
			if ( isdefined( eAttacker ) )
				level.lastLegitimateAttacker = eAttacker;

			if ( ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" ) && isdefined( eInflictor ) && isdefined( eInflictor.isCooked ) )
				self.wasCooked = getTime();
			else
				self.wasCooked = undefined;
			
			self.lastDamageWasFromEnemy = (isdefined( eAttacker ) && (eAttacker != self));

			if ( self.lastDamageWasFromEnemy )
			{
				if ( isplayer( eAttacker ) ) 
				{
					if ( isdefined ( eAttacker.damagedPlayers[ self.clientId ] ) == false )
						eAttacker.damagedPlayers[ self.clientId ] = spawnstruct();
	
					eAttacker.damagedPlayers[ self.clientId ].time = getTime();
					eAttacker.damagedPlayers[ self.clientId ].entity = self;
				}
			}
			
			self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);

			//self thread _missions::playerDamaged(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, sHitLoc );
		}

		if ( isdefined(eAttacker) && isplayer( eAttacker ) && eAttacker != self )
		{			
			if ( doDamageFeedback( weapon, eInflictor, iDamage, sMeansOfDeath ) )
			{
				if ( iDamage > 0 )
				{
					// the perk feedback should be shown only if the enemy is damaged and not killed. 
					if ( self.health > 0 ) 
					{
						perkFeedback = doPerkFeedBack( self, weapon, sMeansOfDeath, eInflictor );
					}
					
					eAttacker thread damagefeedback::updateDamageFeedback( sMeansOfDeath, eInflictor, perkFeedback );
				}
			}
		}
		
		self.hasDoneCombat = true;
	}*/

//	if(self.sessionstate != "dead")
//		self _gametype_variants::onPlayerTakeDamage( eAttacker, eInflictor, weapon, iDamage, sMeansOfDeath );

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

			// Removed a blackbox print for "mpattacks" from here
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";

			// Removed a blackbox print for "mpattacks" from here
		}
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
	
	pixendevent(); // "END: PlayerDamage log"
	
	profilelog_endtiming( 6, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

function resetAttackerList()
{
	self.attackers = [];
	self.attackerData = [];
	self.attackerDamage = [];
	self.firstTimeDamaged = 0;
}

function doDamageFeedback( weapon, eInflictor, iDamage, sMeansOfDeath )
{
	if ( !isdefined( weapon ) )
		return false;

	if ( level.allowHitMarkers == 0 ) 
		return false;

	if ( level.allowHitMarkers == 1 ) // no tac grenades
	{
		if ( isdefined( sMeansOfDeath ) && isdefined( iDamage ) ) 
		{
			if ( isTacticalHitMarker( weapon, sMeansOfDeath, iDamage ) )
			{
				return false;
			}
		}
	}

	return true;
}

function isTacticalHitMarker( weapon, sMeansOfDeath, iDamage )
{

	if ( weapons::is_grenade( weapon ) )
	{
		if ( "Smoke Grenade" == weapon.offhandClass ) 
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

function doPerkFeedBack( player, weapon, sMeansOfDeath, eInflictor )
{
	perkFeedback = undefined;
	/*hasTacticalMask = _class::hasTacticalMask( player );
	hasFlakJacket = ( player HasPerk( "specialty_flakjacket" ) );
	//isExplosiveDamage = _class::isExplosiveDamage( weapon, sMeansOfDeath );
	isFlashOrStunDamage = weapon_utils::isFlashOrStunDamage( weapon, sMeansOfDeath );
						
	if ( isFlashOrStunDamage && hasTacticalMask )
	{
		perkFeedback = "tacticalMask";  
	}
	else if ( isExplosiveDamage && hasFlakJacket && !weapon.ignoresFlakJacket && ( !isAIKillstreakDamage( weapon, eInflictor ) ) )
	{
		perkFeedback = "flakjacket";   	
	}
	*/
	return perkFeedback;
}

function isAIKillstreakDamage( weapon, eInflictor )
{
	if ( weapon.isAIKillstreakDamage )
	{
		if ( weapon.name != "ai_tank_drone_rocket" || isdefined( eInflictor.firedByAI ) )
		{
			return true;
		}
	}
	
	return false;
}

function finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal )
{	
	pixbeginevent("finishPlayerDamageWrapper");

	if( !level.console && iDFlags & level.iDFLAGS_PENETRATION && isplayer ( eAttacker ) )
	{
		/#
		println("penetrated:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);
		#/
		eAttacker AddPlayerStat( "penetration_shots", 1 );
	}
	
	if ( GetDvarString( "scr_csmode" ) != "" )
		self shellShock( "damage", 0.2 );
	
	self damageShellshockAndRumble( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );

	self ability_power::power_loss_event_took_damage( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );
	
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal );

	pixendevent();
}

function allowedAssistWeapon( weapon )
{
	//if ( !_killstreaks::isKillstreakWeapon( weapon ) )
		return true;
		
	//if (_killstreaks::isKillstreakWeaponAssistAllowed(  weapon ) )
	//	return true;
		
	//return false;
}

function Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
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
	
	if ( isdefined( level.takeLivesOnDeath ) && ( level.takeLivesOnDeath == true ) )
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
	
	self thread globallogic_audio::flushGroupDialogOnPlayer( "item_destroyed" );
	
	weapon = updateWeapon( eInflictor, weapon );
	
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
		if ( !level.teamBased || ( !isdefined( attacker ) || !isplayer( attacker ) || attacker.team != self.team || attacker == self ) )
		{
			eInflictor = self.lastStandParams.eInflictor;
			attacker = self.lastStandParams.attacker;
			attackerStance = self.lastStandParams.attackerStance;
			iDamage = self.lastStandParams.iDamage;
			sMeansOfDeath = self.lastStandParams.sMeansOfDeath;
			weapon = self.lastStandParams.weapon;
			vDir = self.lastStandParams.vDir;
			sHitLoc = self.lastStandParams.sHitLoc;
			self.vAttackerOrigin = self.lastStandParams.vAttackerOrigin;
			deathTimeOffset = (gettime() - self.lastStandParams.lastStandStartTime) / 1000;
			
		//	self thread _battlechatter_mp::perkSpecificBattleChatter( "secondchance" );
			
			if ( isdefined( self.previousPrimary ) )
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

	if ( (!isdefined( attacker ) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || ( isdefined( attacker.isMagicBullet ) && attacker.isMagicBullet == true ) || attacker == self ) && isdefined( self.attackers )  )
	{		
		if ( !isdefined(bestPlayer) )
		{
			for ( i = 0; i < self.attackers.size; i++ )
			{
				player = self.attackers[i];
				if ( !isdefined( player ) )
					continue;
				
				if (!isdefined( self.attackerDamage[ player.clientId ] ) || ! isdefined( self.attackerDamage[ player.clientId ].damage ) )
					continue;
				
				if ( player == self || (level.teamBased && player.team == self.team ) )
					continue;
				
				if ( self.attackerDamage[ player.clientId ].lasttimedamaged + 2500 < getTime() )
					continue;			
	
				if ( !allowedAssistWeapon( self.attackerDamage[ player.clientId ].weapon ) )
					continue;
	
				if ( self.attackerDamage[ player.clientId ].damage > 1 && ! isdefined( bestPlayer ) )
				{
					bestPlayer = player;
					bestPlayerMeansOfDeath = self.attackerDamage[ player.clientId ].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[ player.clientId ].weapon;
				}
				else if ( isdefined( bestPlayer ) && self.attackerDamage[ player.clientId ].damage > self.attackerDamage[ bestPlayer.clientId ].damage )
				{
					bestPlayer = player;	
					bestPlayerMeansOfDeath = self.attackerDamage[ player.clientId ].meansOfDeath;
					bestPlayerWeapon = self.attackerDamage[ player.clientId ].weapon;
				}
			}
		}
		if ( isdefined ( bestPlayer ) )
		{
			self RecordKillModifier("assistedsuicide");
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

	if( globallogic_utils::isHeadShot( weapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer( attacker ) )
	{
		attacker playLocalSound( "prj_bullet_impact_headshot_helmet_nodie_2d" );
		//attacker playLocalSound( "prj_bullet_impact_headshot_2d" );

		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	self.deathTime = getTime();
		
	attacker = updateAttacker( attacker, weapon );
	eInflictor = updateInflictor( eInflictor );

	sMeansOfDeath = updateMeansOfDeath( weapon, sMeansOfDeath );
	
	if ( isdefined(self.hasRiotShieldEquipped) && (self.hasRiotShieldEquipped==true) )
	{
		self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
		self.hasRiotShield = false;
		self.hasRiotShieldEquipped = false;
	}

	self thread updateGlobalBotKilledCounter();

	// Don't increment weapon stats for team kills or deaths
	if ( isPlayer( attacker ) && attacker != self && ( !level.teamBased || ( level.teamBased && self.team != attacker.team ) ) )
	{
		self AddWeaponStat( weapon, "deaths", 1 ); 

		if ( wasInLastStand && isdefined( lastWeaponBeforeDroppingIntoLastStand ) ) 
			weapon = lastWeaponBeforeDroppingIntoLastStand;
		else
			weapon = self.lastdroppableweapon;

		if ( isdefined( weapon ) )
		{
			self AddWeaponStat( weapon, "deathsDuringUse", 1 );
		}
		
		if ( sMeansOfDeath != "MOD_FALLING" )
		{
			attacker AddWeaponStat( weapon, "kills", 1 );
		}
		
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
		{
			attacker AddWeaponStat( weapon, "headshots", 1 );
		}
	}
	
	if ( !isdefined( obituaryMeansOfDeath ) ) 
		obituaryMeansOfDeath = sMeansOfDeath;
	if ( !isdefined( obituaryWeapon ) ) 
		obituaryWeapon = weapon;


	if ( !isplayer( attacker ) || ( self util::IsEnemyPlayer( attacker ) == false ) )
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

		if ( level.lastObituaryPlayerCount >= 4 ) 
		{
			level notify( "reset_obituary_count" );
			level.lastObituaryPlayerCount = 0;
			level.lastObituaryPlayer = undefined;
		}
	}

	overrideEntityCamera = false;//_killstreaks::shouldOverrideEntityCameraInDemo( weapon );

	// send out an obituary message to all clients about the kill
	if( level.teamBased && isdefined( attacker.pers ) && self.team == attacker.team && obituaryMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
	{
		obituary(self, self, obituaryWeapon, obituaryMeansOfDeath);
		demo::bookmark( "kill", gettime(), self, self, 0, eInflictor, overrideEntityCamera );
	}
	else
	{
		obituary(self, attacker, obituaryWeapon, obituaryMeansOfDeath);
		demo::bookmark( "kill", gettime(), attacker, self, 0, eInflictor, overrideEntityCamera );
	}

	if ( !level.inGracePeriod )
	{
		self weapons::dropScavengerForDeath( attacker );
		self weapons::dropWeaponForDeath( attacker );
	}

	spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;
	
	self.killedPlayersCurrent = [];
	
	self.deathCount++;

/#
	println( "players("+self.clientId+") death count ++: " + self.deathCount );
#/

	if( !isdefined( self.switching_teams ) )
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
			self  globallogic_score::incPersStat( "deaths", 1, true, true );
			self.deaths = self  globallogic_score::getPersStat( "deaths" );	
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

	self globallogic_score::resetPlayerMomentumOnDeath();

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
			/*
			if ( isdefined( self.switching_teams ) )
			{
				if ( !level.teamBased && ( isdefined( level.teams[ self.leaving_team ] ) &&  isdefined( level.teams[ self.joining_team ] ) && level.teams[ self.leaving_team ] != level.teams[ self.joining_team ] ) )
				{
					playerCounts = self _teams::CountPlayers();
					playerCounts[self.leaving_team]--;
					playerCounts[self.joining_team]++;
				
					if( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
					{
					//	self thread _rank::giveRankXP( "suicide" );	
						self  globallogic_score::incPersStat( "suicides", 1 );
						self.suicides = self  globallogic_score::getPersStat( "suicides" );
					}
				}
			}
			else
			*/
			{
				self  globallogic_score::incPersStat( "suicides", 1 );
				self.suicides = self  globallogic_score::getPersStat( "suicides" );

				if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade )
				{
					self.lastGrenadeSuicideTime = gettime();
				}

				//Check for player death related battlechatter
		//		thread _battlechatter_mp::onPlayerSuicideOrTeamKill( self, "suicide" );	//Play suicide battlechatter
				
				//check if assist points should be awarded
				awardAssists = true;
				self.suicide = true;
			}
			
			if( isdefined( self.friendlydamage ) )
			{
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");
				if ( level.teamKillPointLoss )
					{
						scoreSub = self [[level.getTeamKillScore]]( eInflictor, attacker, sMeansOfDeath, weapon);
						globallogic_score::_setPlayerScore( attacker,globallogic_score::_getPlayerScore( attacker ) - scoreSub );
					}
			}
		}
		else
		{
			pixbeginevent( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;
			
	//		self thread _gametype_variants::playerKilled( attacker );

			if ( level.teamBased && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
			{		
			}
			else if ( level.teamBased && self.team == attacker.team ) // killed by a friendly
			{
				if ( !IgnoreTeamKills( weapon, sMeansOfDeath ) )
				{
					teamkill_penalty = self [[level.getTeamKillPenalty]]( eInflictor, attacker, sMeansOfDeath, weapon);
				
					attacker  globallogic_score::incPersStat( "teamkills_nostats", teamkill_penalty, false );
					attacker  globallogic_score::incPersStat( "teamkills", 1 ); //save team kills to player stats
					attacker.teamkillsThisRound++;
				
					if ( level.teamKillPointLoss )
					{
						scoreSub = self [[level.getTeamKillScore]]( eInflictor, attacker, sMeansOfDeath, weapon);
						globallogic_score::_setPlayerScore( attacker,globallogic_score::_getPlayerScore( attacker ) - scoreSub );
					}
					
					if ( globallogic_utils::getTimePassed() < 5000 )
						teamKillDelay = 1;
					else if ( attacker.pers["teamkills_nostats"] > 1 && globallogic_utils::getTimePassed() < (8000 + (attacker.pers["teamkills_nostats"] * 1000)) )
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
	
				//	//Play teamkill battlechatter
				//	if( isPlayer( attacker ) )
				//		thread _battlechatter_mp::onPlayerSuicideOrTeamKill( attacker, "teamkill" );
				}
			}
			else
			{
				globallogic_score::incTotalKills(attacker.team);
				
				attacker thread globallogic_score::giveKillStats( sMeansOfDeath, weapon, self );

				if ( isAlive( attacker ) )
				{
					pixbeginevent("killstreak");

					if ( !isdefined( eInflictor ) || !isdefined( eInflictor.requiredDeathCount ) || attacker.deathCount == eInflictor.requiredDeathCount )
					{
						shouldGiveKillstreak = false;//_killstreaks::shouldGiveKillstreak( weapon );
						//attacker thread _properks::earnedAKill();

					//	if ( shouldGiveKillstreak )
					//	{
					//		attacker _killstreaks::addToKillstreakCount(eapon);
					//	}

						attacker.pers["cur_total_kill_streak"]++;
						attacker setplayercurrentstreak( attacker.pers["cur_total_kill_streak"] );

						//Kills gotten through killstreak weapons should not the players killstreak
						if ( isdefined( level.killstreaks ) &&  shouldGiveKillstreak )
						{	
							attacker.pers["cur_kill_streak"]++;

						//	if ( !isdefined( level.usingMomentum ) || !level.usingMomentum )
						//	{
						//		attacker thread _killstreaks::giveKillstreakForStreak();
						//	}
						}
					}
				
				//	if( isPlayer( attacker ) )
				//		self thread _battlechatter_mp::onPlayerKillstreak( attacker );

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

			/*	if ( attacker.pers["cur_kill_streak"] > attacker.gametype_kill_streak )
				{
					attacker _persistence::statSetWithGametype( "kill_streak", attacker.pers["cur_kill_streak"] );
					attacker.gametype_kill_streak = attacker.pers["cur_kill_streak"];
				}*/
				
				killstreak = undefined;//_killstreaks::getKillstreakForWeapon( weapon );

				attacker thread  globallogic_score::trackAttackerKill( self.name, self.pers["rank"], self.pers["rankxp"], self.pers["prestige"], self getXuid(true) );	
				
				attackerName = attacker.name;
				self thread  globallogic_score::trackAttackeeDeath( attackerName, attacker.pers["rank"], attacker.pers["rankxp"], attacker.pers["prestige"], attacker getXuid(true) );
		//		self thread _medals::setLastKilledBy( attacker );

				attacker thread  globallogic_score::incKillstreakTracker( weapon );
				
				// to prevent spectator gain score for team-spectator after throwing a granade and killing someone before he switched
				if ( level.teamBased && attacker.team != "spectator")
				{
					// dog score for team
					if( isai(Attacker) )
						globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
					else
						globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
				}

				scoreSub = level.deathPointLoss;
				if ( scoreSub != 0 )
				{
					globallogic_score::_setPlayerScore( self, globallogic_score::_getPlayerScore( self ) - scoreSub );
				}
				
				level thread playKillBattleChatter( attacker, weapon, self );
				
				if ( level.teamBased )
				{
					//check if assist points should be awarded
					awardAssists = true;
				}
			}
			
			pixendevent(); //"PlayerKilled attacker" 
		}
	}
	else if ( isdefined( attacker ) && ( attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" ) )
	{
		doKillcam = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackteam = "world";
		
		self globallogic_score::incPersStat( "suicides", 1 );
		self.suicides = self  globallogic_score::getPersStat( "suicides" );

		//Check for player death related battlechatter
		//thread _battlechatter_mp::onPlayerSuicideOrTeamKill( self, "suicide" );	//Play suicide battlechatter

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
		if ( isdefined( eInflictor ) && isdefined( eInflictor.killCamEnt ) )
		{
			doKillcam = true;
			lpattacknum = self getEntityNumber();
		}

		// even if the attacker isn't a player, it might be on a team
		if ( isdefined( attacker ) && isdefined( attacker.team ) && ( isdefined( level.teams[attacker.team] ) ) )
		{
			if ( attacker.team != self.team ) 
			{
				if ( level.teamBased )
					globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
			}
		}
		//check if assist points should be awarded
		awardAssists = true;
		
	}	
	
	pixbeginevent( "PlayerKilled post constants" );

	self.lastAttacker = attacker;
	self.lastDeathPos = self.origin;

	if ( isdefined( attacker ) && isPlayer( attacker ) && attacker != self && (!level.teambased || attacker.team != self.team) )
	{
		self thread challenges::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, sHitLoc, attackerStance );
	}
	else
	{

		self notify("playerKilledChallengesProcessed");
	}

	if ( isdefined ( self.attackers ))
		self.attackers = [];
	if( isPlayer( attacker ) )
	{
		// Removed a blackbox print for "mpattacks" from here
	}
	else
	{
		// Removed a blackbox print for "mpattacks" from here
	}

	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );
	attackerString = "none";
	if ( isPlayer( attacker ) ) // attacker can be the worldspawn if it's not a player
		attackerString = attacker getXuid() + "(" + lpattackname + ")";
	/#print( "d " + sMeansOfDeath + "(" + weapon.name + ") a:" + attackerString + " d:" + iDamage + " l:" + sHitLoc + " @ " + int( self.origin[0] ) + " " + int( self.origin[1] ) + " " + int( self.origin[2] ) );#/

	level thread globallogic::updateTeamStatus();

	killcamentity = self getKillcamEntity( attacker, eInflictor, weapon );
	killcamentityindex = -1;
	killcamentitystarttime = 0;

	if ( isdefined( killcamentity ) )
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

	self weapons::detach_carry_object_model();
	
	died_in_vehicle= false;
	if (isdefined(self.diedOnVehicle))
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
		if( isdefined(self.usingvehicle) && self.usingvehicle && isdefined(self.vehicleposition) && self.vehicleposition == 1 )
			ragdoll_now = true;
		
		body = self clonePlayer( deathAnimDuration, weapon, attacker );
		self createDeadBody( iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_now, body );
	}
	pixendevent();// "END: PlayerKilled body and gibbing" 

	thread globallogic_spawn::spawnQueuedClient( self.team, attacker );
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	for ( iCB = 0; iCB < level.onPlayerKilledExtraUnthreadedCBs.size; iCB++ )
	{
		self [[ level.onPlayerKilledExtraUnthreadedCBs[ iCB ] ]](
			eInflictor,
			attacker,
			iDamage,
			sMeansOfDeath,
			weapon,
			vDir,
			sHitLoc,
			psOffsetTime,
			deathAnimDuration );
	}	
	
	self.wantSafeSpawn = false;
	perks = [];
	// perks = globallogic::getPerks( attacker );
	killstreaks = globallogic::getKillstreaks( attacker );

	if( !isdefined( self.killstreak_waitamount ) )
	{
		// start the prediction now so the client gets updates while waiting to spawn	
		self thread [[level.spawnPlayerPrediction]]();
	}
	
	profilelog_endtiming( 7, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
	
	// let the player watch themselves die
	wait ( 0.25 );

	self.cancelKillcam = false;
	//self thread _killcam::cancelKillCamOnUse();
	
	defaultPlayerDeathWatchTime = 1.75;
	if ( sMeansOfDeath == "MOD_MELEE_ASSASSINATE" || 0 > weapon.deathCamTime )
	{
		defaultPlayerDeathWatchTime = (deathAnimDuration * 0.001) + 0.5;
	}
	else if ( 0 < weapon.deathCamTime )
	{
		defaultPlayerDeathWatchTime = weapon.deathCamTime;
	}
	
	if ( isdefined ( level.overridePlayerDeathWatchTimer ) ) 
	{
		defaultPlayerDeathWatchTime = [[level.overridePlayerDeathWatchTimer]]( defaultPlayerDeathWatchTime );
	}
	
	globallogic_utils::waitForTimeOrNotifies( defaultPlayerDeathWatchTime );

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
//		level thread _killcam::startFinalKillcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, weapon, self.deathTime, deathTimeOffset, psOffsetTime, perks, killstreaks, attacker );
		return;
	}
	
	self.respawnTimerStartTime = gettime();
	
	if ( !self.cancelKillcam && doKillcam && level.killcam )
	{
		livesLeft = !(level.numLives && !self.pers["lives"]);
		timeUntilSpawn =  globallogic_spawn::TimeUntilSpawn( true );
		willRespawnImmediately = livesLeft && (timeUntilSpawn <= 0) && !level.playerQueuedRespawn;
			
		//self _killcam::killcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, weapon, self.deathTime, deathTimeOffset, psOffsetTime, willRespawnImmediately, globallogic_utils::timeUntilRoundEnd(), perks, killstreaks, attacker );
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
	if ( globallogic_utils::isValidClass( self.curClass ) )
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

function updateGlobalBotKilledCounter()
{
	if ( isdefined( self.pers["isBot"] ) )
	{
		level.globalLarrysKilled++;
	}
}


function WaitTillKillStreakDone()
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

function TeamKillKick()
{
	self  globallogic_score::incPersStat( "sessionbans", 1 );			
	
	self endon("disconnect");
	waittillframeend;
	
	//for test purposes lets lock them out of certain game type for 2mins

	playlistbanquantum = tweakables::getTweakableValue( "team", "teamkillerplaylistbanquantum" );
	playlistbanpenalty = tweakables::getTweakableValue( "team", "teamkillerplaylistbanpenalty" );
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

	if ( self util::is_bot() )
	{
		level notify( "bot_kicked", self.team );
	}
	
	ban( self getentitynumber() );
	globallogic_audio::leaderDialog( "kicked" );		
}

function TeamKillDelay()
{
	teamkills = self.pers["teamkills_nostats"];
	if ( level.minimumAllowedTeamKills < 0 || teamkills <= level.minimumAllowedTeamKills )
		return 0;

	exceeded = (teamkills - level.minimumAllowedTeamKills);
	return level.teamKillSpawnDelay * exceeded;
}


function ShouldTeamKillKick(teamKillDelay)
{
	if ( teamKillDelay && ( level.minimumAllowedTeamKills >= 0 ) )
	{
		// if its more then 5 seconds into the match and we have a delay then just kick them
		if ( globallogic_utils::getTimePassed() >= 5000 )
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

function reduceTeamKillsOverTime()
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


function IgnoreTeamKills( weapon, sMeansOfDeath )
{
	if( SessionModeIsZombiesGame() )
		return true;	
		
	if ( sMeansOfDeath == "MOD_MELEE" )
		return false;
		
	if ( weapon.name == "briefcase_bomb" )
		return true;
		
	if ( weapon.name == "supplydrop" )
		return true;
	
	return false;	
}


function Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	//_laststand::playerlaststand(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );	
}


function damageShellshockAndRumble( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage )
{
	self thread weapons::onWeaponDamage( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );
	self PlayRumbleOnEntity( "damage_heavy" );
}


function createDeadBody( iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body )
{
	if ( sMeansOfDeath == "MOD_HIT_BY_OBJECT" && self GetStance() == "prone" )
	{
		self.body = body;
	//	if ( !isdefined( self.switching_teams ) )
	//		thread _deathicons::addDeathicon( body, self, self.team, 5.0 );

		return;
	}

	if ( isdefined( level.ragdoll_override ) && self [[level.ragdoll_override]]() )
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

	if ( self is_explosive_ragdoll( weapon, eInflictor ) )
	{
		body start_explosive_ragdoll( vDir, weapon );
	}

	thread delayStartRagdoll( body, sHitLoc, vDir, weapon, eInflictor, sMeansOfDeath );

	//if( sMeansOfDeath == "MOD_BURNED" || isdefined( self.burning ) )
	//{
	//	body _burnplayer::burnedToDeath();		
	//}	
	//if ( sMeansOfDeath == "MOD_CRUSH" )
	//{
	//	body globallogic_vehicle::vehicleCrush();
	//}
	
	self.body = body;
//	if ( !isdefined( self.switching_teams ) )
//		thread _deathicons::addDeathicon( body, self, self.team, 5.0 );
}

function is_explosive_ragdoll( weapon, inflictor )
{
	if ( !isdefined( weapon ) )
	{
		return false;
	}

	// destructible explosives
	if ( weapon.name == "destructible_car" || weapon.name == "explodable_barrel" )
	{
		return true;
	}

	// special explosive weapons
	if ( weapon.projExplosionType == "grenade" )
	{
		if ( isdefined( inflictor ) && isdefined( inflictor.stuckToPlayer ) )
		{
			if ( inflictor.stuckToPlayer == self )
			{
				return true;
			}
		}
	}

	return false;
}

function start_explosive_ragdoll( dir, weapon )
{
	if ( !isdefined( self ) )
	{
		return;
	}

	x = RandomIntRange( 50, 100 );
	y = RandomIntRange( 50, 100 );
	z = RandomIntRange( 10, 20 );

	if ( isdefined( weapon ) && ( weapon.name == "sticky_grenade" || weapon.name == "explosive_bolt" ) )
	{
		if ( isdefined( dir ) && LengthSquared( dir ) > 0 )
		{
			x = dir[0] * x;
			y = dir[1] * y;
		}
	}
	else
	{
		if ( math::cointoss() )
		{
			x = x * -1;
		}
		if ( math::cointoss() )
		{
			y = y * -1;
		}
	}

	self StartRagdoll();
	self LaunchRagdoll( ( x, y, z ) );
}


function notifyConnecting()
{
	waittillframeend;

	if( isdefined( self ) )
	{
		level notify( "connecting", self );
		self callback::callback( #"on_player_connecting" );
	}
}


function delayStartRagdoll( ent, sHitLoc, vDir, weapon, eInflictor, sMeansOfDeath )
{
	if ( isdefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}
	
	if ( level.oldschool )
	{
		if ( !isdefined( vDir ) )
			vDir = (0,0,0);
		
		explosionPos = ent.origin + ( 0, 0, globallogic_utils::getHitLocHeight( sHitLoc ) );
		explosionPos -= vDir * 20;
		//thread globallogic_utils::debugLine( ent.origin + (0,0,(explosionPos[2] - ent.origin[2])), explosionPos );
		explosionRadius = 40;
		explosionForce = .75;
		if ( sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_EXPLOSIVE" || isSubStr(sMeansOfDeath, "MOD_GRENADE") || isSubStr(sMeansOfDeath, "MOD_PROJECTILE") || sHitLoc == "head" || sHitLoc == "helmet" )
		{
			explosionForce = 2.5;
		}
		
		ent startragdoll( 1 );
		
		wait .05;
		
		if ( !isdefined( ent ) )
			return;
		
		// apply extra physics force to make the ragdoll go crazy
		physicsExplosionSphere( explosionPos, explosionRadius, explosionRadius/2, explosionForce );
		return;
	}
	
	wait( 0.2 );
	
	if ( !isdefined( ent ) )
		return;
	
	if ( ent isRagDoll() )
		return;
	
	deathAnim = ent getcorpseanim();

	startFrac = 0.35;

	if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
	{
		times = getnotetracktimes( deathAnim, "start_ragdoll" );
		if ( isdefined( times ) )
			startFrac = times[0];
	}

	waitTime = startFrac * getanimlength( deathAnim );
	wait( waitTime );

	if ( isdefined( ent ) )
	{
		ent startragdoll( 1 );
	}
}

function trackAttackerDamage( eAttacker, iDamage, sMeansOfDeath, weapon )
{
	if( !IsDefined( eAttacker ) )
		return;
		
	if ( !IsPlayer( eAttacker ) )
		return;
		
	if ( self.attackerData.size == 0 ) 
	{
		self.firstTimeDamaged = getTime();	
	}
	if ( !isdefined( self.attackerData[eAttacker.clientid] ) )
	{
		self.attackerDamage[eAttacker.clientid] = spawnstruct();
		self.attackerDamage[eAttacker.clientid].damage = iDamage;
		self.attackerDamage[eAttacker.clientid].meansOfDeath = sMeansOfDeath;
		self.attackerDamage[eAttacker.clientid].weapon = weapon;
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
		self.attackerDamage[eAttacker.clientid].weapon = weapon;
		if ( !isdefined( self.attackerDamage[eAttacker.clientid].time ) )
			self.attackerDamage[eAttacker.clientid].time = getTime();
	}

	self.attackerDamage[eAttacker.clientid].lasttimedamaged = getTime();
	if ( weapons::is_primary_weapon( weapon ) )
		self.attackerData[eAttacker.clientid] = true;
}

function giveAttackerAndInflictorOwnerAssist( eAttacker, eInflictor, iDamage, sMeansOfDeath, weapon )
{
	if ( !allowedAssistWeapon( weapon ) )
		return;
		
	self trackAttackerDamage( eAttacker, iDamage, sMeansOfDeath, weapon );
		
	if ( !isdefined( eInflictor ) )
		return;
		
	if ( !isdefined( eInflictor.owner ) )
		return;
		
	if ( !isdefined( eInflictor.ownerGetsAssist ) )
		return;
		
	if ( !eInflictor.ownerGetsAssist )
		return;
	
	// if attacker and inflictor owner are the same no additional points
	// I dont ever know if they are different
	if ( isdefined( eAttacker ) && eAttacker == eInflictor.owner )
		return;
		
	self trackAttackerDamage( eInflictor.owner, iDamage, sMeansOfDeath, weapon );
}

function updateMeansOfDeath( weapon, sMeansOfDeath )
{
	// we do not want the melee icon to show up for dog attacks
	switch ( weapon.name )
	{
	case "knife_ballistic":
		{
			if ( ( sMeansOfDeath != "MOD_HEAD_SHOT" ) && ( sMeansOfDeath != "MOD_MELEE" ) )
			{
				sMeansOfDeath = "MOD_PISTOL_BULLET";
			}
		}
		break;
	case "dog_bite":
		sMeansOfDeath = "MOD_PISTOL_BULLET";
		break;
	case "destructible_car":
		sMeansOfDeath = "MOD_EXPLOSIVE";
		break;
	case "explodable_barrel":
		sMeansOfDeath = "MOD_EXPLOSIVE";
		break;
	}

	return sMeansOfDeath;
}

function updateAttacker( attacker, weapon )
{
	if( isai(attacker) && isdefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( !level.teambased || attacker.script_owner.team != self.team )
			attacker = attacker.script_owner;
	}
	
	if( attacker.classname == "script_vehicle" && isdefined( attacker.owner ) )
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
		
	if( isdefined( attacker ) && isdefined( weapon ) && weapon.name == "planemortar" )
	{
		if ( !isdefined( attacker.planeMortarBda ) )
		{
			attacker.planeMortarBda = 0;
		}
		attacker.planeMortarBda ++;	
	}	
	
	return attacker;
}

function updateInflictor( eInflictor )
{
	if( isdefined( eInflictor ) && eInflictor.classname == "script_vehicle" )
	{
		eInflictor notify("killed",self);
		
		if ( isdefined( eInflictor.bda ) )
		{
			eInflictor.bda++;
		}
	}
	
	return eInflictor;
}

function updateWeapon( eInflictor, weapon )
{
	// explosive barrel/car detection
	if ( weapon == level.weaponNone && isdefined( eInflictor ) )
	{
		if ( isdefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
			weapon = GetWeapon( "explodable_barrel" );
		else if ( isdefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
			weapon = GetWeapon( "destructible_car" );
	}
	
	return weapon;
}

function getClosestKillcamEntity( attacker, killCamEntities, depth )
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
		if ( isdefined( killcamEnt.offsetPoint ) )
			origin += killcamEnt.offsetPoint;

		dist = DistanceSquared( self.origin, origin );

		if ( !isdefined( closestKillcamEnt ) || dist < closestKillcamEntDist )
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

function getKillcamEntity( attacker, eInflictor, weapon )
{
	if ( !isdefined( eInflictor ) )
		return undefined;

	if ( eInflictor == attacker )
	{
		if( !isdefined( eInflictor.isMagicBullet ) )
			return undefined;
		if( isdefined( eInflictor.isMagicBullet ) && !eInflictor.isMagicBullet )
			return undefined;
	}
	else if ( isdefined( level.levelSpecificKillcam ) )
	{
		levelSpecificKillcamEnt = self [[level.levelSpecificKillcam]]();
		if ( isdefined( levelSpecificKillcamEnt ) )
			return levelSpecificKillcamEnt;
	}
	
	if ( weapon.name == "m220_tow" )
		return undefined;
	
	if ( isdefined(eInflictor.killCamEnt) )
	{
		// this is the case with the player helis
		if ( eInflictor.killCamEnt == attacker )
			return undefined;
			
		return eInflictor.killCamEnt;
	}
	else if ( isdefined(eInflictor.killCamEntities) )
	{
		return getClosestKillcamEntity( attacker, eInflictor.killCamEntities );
	}
	
	if ( isdefined( eInflictor.script_gameobjectname ) && eInflictor.script_gameobjectname == "bombzone" )
		return eInflictor.killCamEnt;

	return eInflictor;
}
	
function playKillBattleChatter( attacker, weapon, victim )
{
	/*if( IsPlayer( attacker ) )
	{
		//if ( !_killstreaks::isKillstreakWeapon( weapon ) )
		{
			level thread _battlechatter_mp::sayKillBattleChatter( attacker, weapon, victim );
		}
	}*/
}

