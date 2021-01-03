#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_deathicons;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_globallogic_vehicle;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_persistence;
#using scripts\mp\gametypes\_rank;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_behavior_tracker;
#using scripts\shared\_burnplayer;
#using scripts\mp\_challenges;
#using scripts\mp\_gamerep;
#using scripts\mp\_medals;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_straferun;
#using scripts\mp\teams\_teams;

#namespace globallogic_player;

function freezePlayerForRoundEnd()
{
	self util::clearLowerMessage();
	
	self closeInGameMenu();
	
	self util::freeze_player_controls( true );
	
	if( !SessionModeIsZombiesGame() )
	{
		currentWeapon = self GetCurrentWeapon();
		if ( killstreaks::is_killstreak_weapon( currentWeapon ) && !currentWeapon.isCarriedKillstreak )
			self takeWeapon( currentWeapon );
	}

	//self util::_disableWeapon();
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

	MatchRecorderIncrementHeaderStat( "playerCountJoined", 1 );

	profilelog_begintiming( 4, "ship" );

	level notify( "connected", self );
	callback::callback( #"on_player_connect" );
	
	if ( self IsHost() )
		self thread globallogic::listenForGameEnd();

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
	{
		iPrintLn(&"MP_CONNECTED", self);
	}

	if( !isdefined( self.pers["score"] ) )
	{
		self thread persistence::adjust_recent_stats();
		self persistence::set_after_action_report_stat( "valid", 0 );		
		if ( GameModeIsMode( 3 ) && !( self IsHost() ) )
			self persistence::set_after_action_report_stat( "wagerMatchFailed", 1 );
		else
			self persistence::set_after_action_report_stat( "wagerMatchFailed", 0 );
	}
	
	// track match and hosting stats once per match
	if( ( level.rankedMatch || level.wagerMatch || level.leagueMatch ) && !isdefined( self.pers["matchesPlayedStatsTracked"] ) )
	{
		gameMode = globallogic::GetCurrentGameMode();
		self globallogic::IncrementMatchCompletionStat( gameMode, "played", "started" );
				
		if ( !isdefined( self.pers["matchesHostedStatsTracked"] ) && self IsLocalToHost() )
		{
			self globallogic::IncrementMatchCompletionStat( gameMode, "hosted", "started" );
			self.pers["matchesHostedStatsTracked"] = true;
		}
		
		self.pers["matchesPlayedStatsTracked"] = true;
		self thread persistence::upload_stats_soon();
	}

	self gamerep::gameRepPlayerConnected();

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	bbPrint( "global_joins", "name %s client %s", self.name, lpselfnum );
	
	if( !SessionModeIsZombiesGame() ) // it will be set after intro screen is faded out for zombie
	{
		self setClientUIVisibilityFlag( "hud_visible", 1 );
		self setClientUIVisibilityFlag( "weapon_hud_visible", 1 );
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
		
		self  globallogic_score::initPersStat( "pointstowin" );
		if ( level.scoreRoundWinBased )
		{
			self.pers["pointstowin"] = 0;
		}
		self.pointstowin = self.pers["pointstowin"];

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
		
		self  globallogic_score::initPersStat( "sbtimeplayed", false );
		self.sbtimeplayed = self  globallogic_score::getPersStat( "sbtimeplayed" );
	
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
		
		self  globallogic_score::initPersStat( "killsconfirmed", false );
		self.killsconfirmed = self  globallogic_score::getPersStat( "killsconfirmed" );
		
		self  globallogic_score::initPersStat( "killsdenied", false );
		self.killsdenied = self  globallogic_score::getPersStat( "killsdenied" );

		self  globallogic_score::initPersStat( "rescues", false );
		self.rescues = self  globallogic_score::getPersStat( "rescues" );

		self globallogic_score::initPersStat( "shotsfired", false );
		self.shotsfired = self   globallogic_score::getPersStat( "shotsfired" );
		
		self globallogic_score::initPersStat( "shotshit", false );
		self.shotshit = self     globallogic_score::getPersStat( "shotshit" );
		
		self globallogic_score::initPersStat( "shotsmissed", false );
		self.shotsmissed = self	 globallogic_score::getPersStat( "shotsmissed" );
		
		self globallogic_score::initPersStat( "victory", false );
		self.victory = self      globallogic_score::getPersStat( "victory" );
		
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

		self behaviorTracker::Initialize();
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

	self.scorestreakDialogQueue = [];
	self.scorestreakDialogPlaying = false;
	
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
	
	if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks && !IsDefined( self.pers["held_killstreak_clip_count"] ) )
		self.pers["held_killstreak_clip_count"] = [];

	if( !isDefined( self.pers["changed_class"] ) )
		self.pers["changed_class"] = false;

	if( !isDefined( self.pers["lastroundscore"] ) )
		self.pers["lastroundscore"] = 0;

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
		self.gametype_kill_streak = self persistence::stat_get_with_gametype( "kill_streak" );
	}

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

	// don't count losses for CTF and S&D and War at each round.
	if ( ( level.rankedMatch || level.wagerMatch || level.leagueMatch ) && !isdefined( self.pers["lossAlreadyReported"] ) )
	{
		if ( level.leagueMatch ) 
		{
			self recordLeaguePreLoser();
		}
		
		globallogic_score::updateLossStats( self );

		self.pers["lossAlreadyReported"] = true;
	}

	// don't redo winstreak save to pers array for each round of round based games.
	if ( !isdefined( self.pers["winstreakAlreadyCleared"] ) )
	{
		self  globallogic_score::backupAndClearWinStreaks();
		self.pers["winstreakAlreadyCleared"] = true;
	}
		
	if( self istestclient() )
	{
		self.pers[ "isBot" ] = true;
	}
	
	if ( level.rankedMatch || level.leagueMatch )
	{
		self persistence::set_after_action_report_stat( "demoFileID", "0" );
	}
	
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
		
		[[level.autoassign]]( false );
		if ( level.rankedMatch || level.leagueMatch )
		{	
			self thread globallogic_spawn::kickIfDontSpawn();
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
			self thread spectating::set_permissions();
		}
	}
	else if ( self.pers["team"] == "spectator" )
	{
		self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
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
		
		self thread spectating::set_permissions();
	}

	if ( self.sessionteam != "spectator" )
	{
		self thread spawning::onSpawnPlayer_Unified(true);
	}

	if ( level.forceRadar == 1 ) // radar always sweeping
	{
		self.pers["hasRadar"] = true;
		self.hasSpyplane = true;
		
		if ( level.teambased )
		{
			level.activeUAVs[self.team]++;
		}
		else
		{
			level.activeUAVs[self getEntityNumber()]++;
		}
		
		level.activePlayerUAVs[self getEntityNumber()]++;
	}
	
	if ( level.forceRadar == 2 ) // radar constant
	{
		self setClientUIVisibilityFlag( "g_compassShowEnemies", level.forceRadar );
	}
	else
	{
		self SetClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
	}
	
	profilelog_endtiming( 4, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );

	if ( isdefined( self.pers["isBot"] ) )
		return;
	
	//T7 - moved from load_shared to make sure this doesn't get set on CP until level.players is ready
	num_con = getnumconnectedplayers();
	num_exp = getnumexpectedplayers();
	/#println( "all_players_connected(): getnumconnectedplayers=", num_con, "getnumexpectedplayers=", num_exp );#/
		
	if(num_con == num_exp && (num_exp != 0))
	{
		level flag::set( "all_players_connected" );
        // CODER_MOD: GMJ (08/28/08): Setting dvar for use by code
        SetDvar( "all_players_are_connected", "1" );
	}	
}

function spectate_player_watcher()
{
	self endon( "disconnect" );
	
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
	
	level.hostMigrationReturnedPlayerCount++;
	if ( level.hostMigrationReturnedPlayerCount >= level.players.size * 2 / 3 )
	{
	/#	println( "2/3 of players have finished migrating" );	#/
		level notify( "hostmigration_enoughplayers" );
	}
}

function Callback_PlayerDisconnect()
{
	profilelog_begintiming( 5, "ship" );

	if ( game["state"] != "postgame" && !level.gameEnded )
	{
		gameLength = globallogic::getGameLength();
		self globallogic::bbPlayerMatchEnd( gameLength, "MP_PLAYER_DISCONNECT", 0 );
	}

	self behaviorTracker::Finalize();

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
	
	self gamerep::gameRepPlayerDisconnected();
	
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

function Callback_PlayerMelee( eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit  )
{
	hit = true;
	
	if ( level.teamBased && self.team == eAttacker.team )
	{
		if ( level.friendlyfire == 0 ) // no one takes damage
		{
			hit = false;
		}
	}
	
	self finishMeleeHit( eAttacker, weapon, vOrigin, vDir, boneIndex, shieldHit, hit );
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

function figure_out_attacker( eAttacker )
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
		else if( eAttacker.classname == "actor_spawner_bo3_robot_grunt_assault_mp" && isdefined( eAttacker.owner ) )
			eAttacker = eAttacker.owner;
	}

	return eAttacker;
}

function player_damage_figure_out_weapon( weapon, eInflictor )
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
		else if( isdefined( eInflictor.scriptvehicletype ) )
		{	
			veh_weapon = GetWeapon( eInflictor.scriptvehicletype );
			if( isdefined( veh_weapon ) )
			{
				weapon = veh_weapon;
			}
		}
	}

	if ( isdefined( eInflictor ) && isdefined( eInflictor.script_noteworthy ) )
	{
		if ( IsDefined( level.overrideWeaponFunc ) )
		{
			weapon = [[level.overrideWeaponFunc]]( weapon, eInflictor.script_noteworthy );
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

	return weapon.immunityForOwner || weapon.doNotDamageOwner;
}

function should_do_player_damage( eAttacker, sMeansOfDeath )
{
	if ( game["state"] == "postgame" )
		return false;
	
	if ( self.sessionteam == "spectator" )
		return false; 
	
	if ( isdefined( self.canDoCombat ) && !self.canDoCombat )
		return false;
	
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isdefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return false;

	if ( isdefined( level.hostMigrationTimer ) )
		return false;
	
	if ( level.onlyHeadShots )
	{
		if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
			return false;
	}
	
	// Make all vehicle drivers invulnerable to bullets
	if ( self vehicle::player_is_occupant_invulnerable( sMeansOfDeath ) )
		return;

return true;
}

function modify_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	if ( isdefined( self.overridePlayerDamage ) )
	{
		iDamage = self [[self.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
	}
	else if ( isdefined( level.overridePlayerDamage ) )
	{
		iDamage = self [[level.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
	}

	assert(isdefined(iDamage), "You must return a value from a damage override function.");
	
	if ( isdefined( eAttacker ) ) 
	{
		iDamage = loadout::cac_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc );
	}
	iDamage = custom_gamemodes_modified_damage( self, eAttacker, iDamage, sMeansOfDeath, weapon, eInflictor, sHitLoc );
	
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
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
			iDamage = 150;
	}
	
	if ( sHitLoc == "riotshield" )
	{
	}
	return int(iDamage);
}

function modify_player_damage_meansofdeath( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	if ( globallogic_utils::isHeadShot( weapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer(eAttacker) && !weapon_utils::ismeleemod( sMeansOfDeath ) )
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	if ( isdefined( eInflictor ) && isdefined( eInflictor.script_noteworthy ) )
	{
		if ( eInflictor.script_noteworthy == "ragdoll_now" )
		{
			sMeansOfDeath = "MOD_FALLING";
		}
	}
	
	return sMeansOfDeath;
}

function player_damage_update_attacker( eInflictor, eAttacker, sMeansOfDeath )
{
	if ( isdefined( eInflictor ) && isPlayer( eAttacker ) && eAttacker == eInflictor ) 
	{
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" || sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
		{
			if ( isPlayer( eAttacker ) )
			{
				eAttacker.hits++;
			}
		}
	}
	
	if ( isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
}

function player_damage_update_explosive_info( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	if ( isdefined( eInflictor ) && ( sMeansOfDeath == "MOD_GAS" || loadout::isExplosiveDamage( sMeansOfDeath ) ) )
	{
		// protect players from spawnkill grenades, tabun and incendiary
		if ( eInflictor.classname == "grenade"  && (self.lastSpawnTime + 3500) > getTime() && DistanceSquared( eInflictor.origin, self.lastSpawnPoint.origin ) < 250 * 250 )
		{
			return false;
		}
		
		// protect players from their own non-player controlled killstreaks
		if ( self isPlayerImmuneToKillstreak( eAttacker, weapon ) )
		{
			return false;
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
		
		isFrag = ( weapon.name == "frag_grenade" );

		if ( isdefined( eAttacker ) && eAttacker != self )
		{
			if ( isdefined( eAttacker ) && isdefined( eInflictor.owner ) && (weapon.name == "satchel_charge" || weapon.name == "claymore" || weapon.name == "bouncingbetty") )
			{
				self.explosiveInfo["originalOwnerKill"] = (eInflictor.owner == self);
				self.explosiveInfo["damageExplosiveKill"] = isdefined( eInflictor.wasDamaged );
				self.explosiveInfo["chainKill"] = isdefined( eInflictor.wasChained );
				self.explosiveInfo["wasJustPlanted"] = isdefined( eInflictor.wasJustPlanted );
				self.explosiveInfo["bulletPenetrationKill"] = isdefined( eInflictor.wasDamagedFromBulletPenetration );
				self.explosiveInfo["cookedKill"] = false;
			}
			if ( isdefined( eInflictor ) && isdefined( eInflictor.stuckToPlayer ) && weapon.projExplosionType == "grenade" )
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
			self globallogic_score::setInflictorStat( eInflictor, eAttacker, weapon );
		}

		if ( weapon.name == "hatchet" && isdefined( eInflictor ) )
		{
			self.explosiveInfo["projectile_bounced"] = isdefined( eInflictor.bounced );
		}
	}
	
	return true;
}

function player_damage_is_friendly_fire_at_round_start()
{
	//check for friendly fire at the begining of the match. apply the damage to the attacker only
	if( level.friendlyFireDelay && level.friendlyFireDelayTime >= ( ( ( gettime() - level.startTime ) - level.discardTime ) / 1000 ) )
	{
		return true;
	}
	
	return false;
}

function player_damage_does_friendly_fire_damage_attacker( eAttacker )
{
	if ( !IsAlive( eAttacker ) )
		return false;
		
	if ( level.friendlyfire == 1 ) // the friendly takes damage
	{
		//check for friendly fire at the begining of the match. apply the damage to the attacker only
		if( player_damage_is_friendly_fire_at_round_start() )
		{
			return true;
		}
	}
	
	if ( level.friendlyfire == 2 ) // only the attacker takes damage
	{
		return true;
	}
	
	if ( level.friendlyfire == 3 )  // both friendly and attacker take damage
	{
		return true;
	}
	
	return false;
}

function player_damage_does_friendly_fire_damage_victim( )
{
	if ( level.friendlyfire == 1 ) // the friendly takes damage
	{
		//check for friendly fire at the begining of the match. apply the damage to the attacker only
		if( player_damage_is_friendly_fire_at_round_start() )
		{
			return false;
		}
		
		return true;
	}
	
	if ( level.friendlyfire == 3 )  // both friendly and attacker take damage
	{
		return true;
	}
	
	return false;
}

function player_damage_riotshield_hit( eAttacker, iDamage, sMeansOfDeath, weapon, attackerIsHittingTeammate)
{
		if (( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" ) &&
			( !killstreaks::is_killstreak_weapon( weapon )) &&
			( !attackerIsHittingTeammate ) )
		{
			if ( self.hasRiotShieldEquipped )
			{
				if ( isPlayer( eAttacker ))
				{
					eAttacker.lastAttackedShieldPlayer = self;
					eAttacker.lastAttackedShieldTime = getTime();
				}

				previous_shield_damage = self.shieldDamageBlocked;
				self.shieldDamageBlocked += iDamage;

				if (( self.shieldDamageBlocked % 400 /*riotshield_damage_score_threshold*/ ) < ( previous_shield_damage % 400 /*riotshield_damage_score_threshold*/ ))
				{
					score_event = "shield_blocked_damage";

					if (( self.shieldDamageBlocked > 2000 /*riotshield_damage_score_max*/ ))
					{
						score_event = "shield_blocked_damage_reduced";	
					}
					
					if ( isdefined( level.scoreInfo[ score_event ]["value"] ) )
					{
						// need to get the actual riot shield weapon here
						self AddWeaponStat( level.weaponRiotshield, "score_from_blocked_damage", level.scoreInfo[ score_event ]["value"] );
					}

					thread scoreevents::processScoreEvent( score_event, self );
				}
			}
		}

}

function player_damage_log( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
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
			isusingheropower = 0;
			
			if ( eAttacker ability_player::is_using_any_gadget() )
				isusingheropower = 1;
					
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d",
				           gettime(), getplayerspawnid( eAttacker ), weapon.name, lpattackerorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 0, isusingheropower ); 
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
			bbPrint( "mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d",
				           gettime(), weapon.name, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 0, 0 ); 
		}
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + weapon.name + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
	
	pixendevent(); // "END: PlayerDamage log"
}

function Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal )
{
	profilelog_begintiming( 6, "ship" );
	
	if ( !(self should_do_player_damage( eAttacker, sMeansOfDeath )) )
		return;
	
	if ( self.scene_takedamage === false )
	{
		return;
	}
	
	iDamage = modify_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
	sMeansOfDeath = modify_player_damage_meansofdeath( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
	
	self callback::callback( #"on_player_damage" );


	if( !isdefined(eAttacker) || !isdefined( self.team ) || self.team == "free" || ( isdefined( eAttacker.team ) && self.team != eAttacker.team ) || ( isdefined( level.hardcoreMode ) && level.hardcoreMode ) )
	{
		self notify( "snd_pain_player", sMeansOfDeath );
	}

	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	friendly = false;

	eAttacker = figure_out_attacker( eAttacker );
	player_damage_update_attacker( eInflictor, eAttacker, sMeansOfDeath );
	
	weapon = player_damage_figure_out_weapon( weapon, eInflictor );

	pixbeginevent( "PlayerDamage flags/tweaks" );

	// Don't do knockback if the damage direction was not specified
	if( !isdefined( vDir ) )
		iDFlags |= 4;

	attackerIsHittingTeammate = isPlayer( eAttacker ) && ( self util::IsEnemyPlayer( eAttacker ) == false );

	if ( !attackerIsHittingTeammate )
	{
		self.lastAttackWeapon = weapon;
	}
	
	pixendevent(); //  "END: PlayerDamage flags/tweaks"
	
	//if( iDFlags & IDFLAGS_PENETRATION && isplayer ( eAttacker ) && eAttacker hasPerk( "specialty_bulletpenetration" ) )
	//	self thread battlechatter::perk_specific_battle_chatter( "deepimpact", true );

	if ( sHitLoc == "riotshield" )
	{
		if ( attackerIsHittingTeammate && level.friendlyfire == 0 )
		{
			return;
		}

		player_damage_riotshield_hit( eAttacker, iDamage, sMeansOfDeath, weapon, attackerIsHittingTeammate);
		
		if ( iDFlags & 32 )
		{
			if ( !(iDFlags & 64) )
			{
				iDamage *= 0.0;
			}
		} 
		else if ( iDFlags & 128 )
		{
			if ( isdefined( eInflictor ) && isdefined( eInflictor.stuckToPlayer ) && eInflictor.stuckToPlayer == self )
			{
				//does enough damage to shield carrier to ensure death		
				iDamage = 101;
			}
		}
		else
		{
			return;
		}		
		
		sHitLoc = "none";	// code ignores any damage to a "shield" bodypart.
	}
	
	// check for completely getting out of the damage
	if( !(iDFlags & 2048) )
	{
		if ( !player_damage_update_explosive_info( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex ) )
			return;

		prevHealthRatio = self.health / self.maxhealth;
		
		attackerIsHittingSelf = IsPlayer( eAttacker ) && (self == eAttacker);
		
		if ( level.teamBased && !attackerIsHittingSelf && attackerIsHittingTeammate )
		{
			pixmarker( "BEGIN: PlayerDamage player" ); // profs automatically end when the function returns
		
			// half damage
			if ( level.friendlyfire == 2 || level.friendlyfire == 3 )
			{
				iDamage = int(iDamage * .5);
			}
			
			// Make sure at least one point of damage is done & give back 1 health because of this if you have power armor
			if ( iDamage < 1 )
			{
				if( ( self ability_util::gadget_power_armor_on() ) && isDefined( self.maxHealth ) && ( self.health < self.maxHealth )  )
				{
					self.health += 1;
				}	
				iDamage = 1;
			}

			if ( player_damage_does_friendly_fire_damage_victim() )
			{
					self.lastDamageWasFromEnemy = false;
						
					self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
			}
			else
			{
				if ( weapon.forceDamageShellshockAndRumble )
				{
					self damageShellshockAndRumble( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );
				}
				
				if ( level.friendlyfire == 0 ) // no one takes damage
					return;
			}
			
			if ( player_damage_does_friendly_fire_damage_attacker( eAttacker ) )
			{
					eAttacker.lastDamageWasFromEnemy = false;
				
					eAttacker.friendlydamage = true;
					eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
					eAttacker.friendlydamage = undefined;
			}
			
			friendly = true;
			pixmarker( "END: PlayerDamage player" );
		}
		else
		{
			// Make sure at least one point of damage is done & give back 1 health because of this if you have power armor
			if ( iDamage < 1 )
			{
				if( ( self ability_util::gadget_power_armor_on() ) && isDefined( self.maxHealth ) && ( self.health < self.maxHealth )  )
				{
					self.health += 1;
				}	
				iDamage = 1;
			}

			behaviorTracker::UpdatePlayerDamage( eAttacker, self, iDamage ); 
			
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
			
			self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
		}

		if ( isdefined(eAttacker) && isplayer( eAttacker ) && eAttacker != self )
		{			
			if ( damagefeedback::doDamageFeedback( weapon, eInflictor, iDamage, sMeansOfDeath ) )
			{
				// the perk feedback should be shown only if the enemy is damaged and not killed. 
				if ( iDamage > 0 && self.health > 0   ) 
				{
					perkFeedback = doPerkFeedBack( self, weapon, sMeansOfDeath, eInflictor );
				}
				
				eAttacker thread damagefeedback::update( sMeansOfDeath, eInflictor, perkFeedback, weapon, self );
			}
		}
		
		self.hasDoneCombat = true;
	}

	if( weapon.isEmp && sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		if( self hasperk("specialty_immuneemp") )
		{
			return;
		}
		
		self notify( "emp_grenaded", eAttacker, vPoint );
	}
	
	if ( isdefined( eAttacker ) && eAttacker != self && !friendly )
		level.useStartSpawns = false;

	player_damage_log( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
	
	profilelog_endtiming( 6, "gs=" + game["state"] + " zom=" + SessionModeIsZombiesGame() );
}

function resetAttackerList()
{
	self.attackers = [];
	self.attackerData = [];
	self.attackerDamage = [];
	self.firstTimeDamaged = 0;
}

function doPerkFeedBack( player, weapon, sMeansOfDeath, eInflictor )
{
	perkFeedback = undefined;
	hasTacticalMask = loadout::hasTacticalMask( player );
	hasFlakJacket = ( player HasPerk( "specialty_flakjacket" ) );
	isExplosiveDamage = loadout::isExplosiveDamage( sMeansOfDeath );
	isFlashOrStunDamage = weapon_utils::isFlashOrStunDamage( weapon, sMeansOfDeath );

	if ( isFlashOrStunDamage && hasTacticalMask )
	{
		perkFeedback = "tacticalMask";
	}
	else if ( player HasPerk( "specialty_fireproof" ) && loadout::isFireDamage( weapon, sMeansOfDeath ) )
	{
		perkFeedback = "flakjacket";
	}
	else if ( isExplosiveDamage && hasFlakJacket && !weapon.ignoresFlakJacket && ( !isAIKillstreakDamage( weapon, eInflictor ) ) )
	{
		perkFeedback = "flakjacket";
	}

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

	if( !level.console && iDFlags & 8 && isplayer ( eAttacker ) )
	{
		/#
		println("penetrated:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);
		#/
		eAttacker AddPlayerStat( "penetration_shots", 1 );
	}
	
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal );
	
	if ( GetDvarString( "scr_csmode" ) != "" )
		self shellShock( "damage_mp", 0.2 );
	
	self damageShellshockAndRumble( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );

	self ability_power::power_loss_event_took_damage( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );

	pixendevent();
}

function allowedAssistWeapon( weapon )
{
	if ( !killstreaks::is_killstreak_weapon( weapon ) )
		return true;
		
	if (killstreaks::is_killstreak_weapon_assist_allowed(  weapon ) )
		return true;
		
	return false;
}

function PlayerKilled_Killstreaks( attacker, weapon )
{
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
				if ( level.rankedMatch && !level.disableStatTracking ) 
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
	
	if ( !SessionModeIsZombiesGame() && killstreaks::is_killstreak_weapon( weapon ) )
	{
		level.globalKillstreaksDeathsFrom++;
	}
}

function PlayerKilled_WeaponStats( attacker, weapon, sMeansOfDeath, wasInLastStand, lastWeaponBeforeDroppingIntoLastStand, inflictor )
{
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
			if ( weapon.name == "explosive_bolt" && IsDefined( inflictor ) && IsDefined( inflictor.ownerWeaponAtLaunch ) && inflictor.ownerAdsAtLaunch )
			{
				attacker AddWeaponStat( inflictor.ownerWeaponAtLaunch, "kills", 1, attacker.class_num, true );
			}
			else
			{
				attacker AddWeaponStat( weapon, "kills", 1, attacker.class_num );
			}

		}
		
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
		{
			attacker AddWeaponStat( weapon, "headshots", 1 );
		}
		
		if ( sMeansOfDeath == "MOD_PROJECTILE" )
		{
			attacker AddWeaponStat( weapon, "direct_hit_kills", 1 );
		}
	}
}

function PlayerKilled_Obituary( attacker, eInflictor, weapon, sMeansOfDeath )
{
	if ( !isplayer( attacker ) || ( self util::IsEnemyPlayer( attacker ) == false ) || ( isdefined ( weapon ) && killstreaks::is_killstreak_weapon( weapon ) ) )
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

		level thread scoreevents::decrementLastObituaryPlayerCountAfterFade();

		if ( level.lastObituaryPlayerCount >= 4 ) 
		{
			level notify( "reset_obituary_count" );
			level.lastObituaryPlayerCount = 0;
			level.lastObituaryPlayer = undefined;
			self thread scoreevents::uninterruptedObitFeedKills( attacker, weapon );
		}
	}

	if ( !isplayer( attacker ) || ( isdefined( weapon ) && !killstreaks::is_killstreak_weapon( weapon ) ) )
	{
		behaviorTracker::UpdatePlayerKilled( attacker, self ); 
	}

	overrideEntityCamera = killstreaks::should_override_entity_camera_in_demo( attacker, weapon );

	if( isdefined( eInflictor ) && ( eInflictor.archetype === "robot" ) )
		sMeansOfDeath = "MOD_RIFLE_BULLET";
	// send out an obituary message to all clients about the kill
	if( level.teamBased && isdefined( attacker.pers ) && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
	{
		obituary(self, self, weapon, sMeansOfDeath);
		demo::bookmark( "kill", gettime(), self, self, 0, eInflictor, overrideEntityCamera );
	}
	else
	{
		obituary(self, attacker, weapon, sMeansOfDeath);
		demo::bookmark( "kill", gettime(), attacker, self, 0, eInflictor, overrideEntityCamera );
	}
}

function PlayerKilled_Suicide( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc )
{
	awardAssists = false;
	self.suicide = false;

	// switching teams
	if ( isdefined( self.switching_teams ) )
	{

		if ( !level.teamBased && ( isdefined( level.teams[ self.leaving_team ] ) &&  isdefined( level.teams[ self.joining_team ] ) && level.teams[ self.leaving_team ] != level.teams[ self.joining_team ] ) )
		{
			playerCounts = self teams::count_players();
			playerCounts[self.leaving_team]--;
			playerCounts[self.joining_team]++;
		
			if( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
			{
				thread scoreevents::processScoreEvent( "suicide", self );
				self thread rank::giveRankXP( "suicide" );	
				self  globallogic_score::incPersStat( "suicides", 1 );
				self.suicides = self  globallogic_score::getPersStat( "suicides" );
				self.suicide = true;
			}
		}
	}
	else
	{
		thread scoreevents::processScoreEvent( "suicide", self );
		self  globallogic_score::incPersStat( "suicides", 1 );
		self.suicides = self  globallogic_score::getPersStat( "suicides" );

		if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade )
		{
			self.lastGrenadeSuicideTime = gettime();
		}

		if ( level.maxSuicidesBeforeKick > 0 && level.maxSuicidesBeforeKick <= self.suicides )
		{
			// should change "teamKillKicked" to just kicked for the next game
			self notify( "teamKillKicked" );
			self SuicideKick();
		}
		
		//Check for player death related battlechatter
		thread battlechatter::on_player_suicide_or_team_kill( self, "suicide" );	//Play suicide battlechatter
		
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
			
			score = globallogic_score::_getPlayerScore( attacker ) - scoreSub;
			
			if ( score < 0 )
				score = 0;
				
			globallogic_score::_setPlayerScore( attacker, score );
		}
	}
	
	return awardAssists;
}

function PlayerKilled_TeamKill( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc )
{
	thread scoreevents::processScoreEvent( "team_kill", attacker );

	self.teamKilled = true;
	
	if ( !IgnoreTeamKills( weapon, sMeansOfDeath ) )
	{
		teamkill_penalty = self [[level.getTeamKillPenalty]]( eInflictor, attacker, sMeansOfDeath, weapon);
	
		attacker  globallogic_score::incPersStat( "teamkills_nostats", teamkill_penalty, false );
		attacker  globallogic_score::incPersStat( "teamkills", 1 ); //save team kills to player stats
		attacker.teamkillsThisRound++;
	
		if ( level.teamKillPointLoss )
		{
			scoreSub = self [[level.getTeamKillScore]]( eInflictor, attacker, sMeansOfDeath, weapon);
			
			score = globallogic_score::_getPlayerScore( attacker ) - scoreSub;
			
			if ( score < 0 )
			{
				score = 0;
			}
			
			globallogic_score::_setPlayerScore( attacker, score );
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
			attacker thread wait_and_suicide(); // can't eject the teamkilling player same frame bc it purges EV_FIRE_WEAPON fx
			
			if ( attacker ShouldTeamKillKick(teamKillDelay) )
			{
				// should change "teamKillKicked" to just kicked for the next game
				attacker notify( "teamKillKicked" );
				attacker TeamKillKick();
			}

			attacker thread reduceTeamKillsOverTime();			
		}

		//Play teamkill battlechatter
		if( isPlayer( attacker ) )
			thread battlechatter::on_player_suicide_or_team_kill( attacker, "teamkill" );
	}
}

function wait_and_suicide() // self == player
{
	self endon( "disconnect" );
	self util::freeze_player_controls( true );

	wait .25;

	self suicide();
}

function PlayerKilled_AwardAssists( eInflictor, attacker, weapon, lpattackteam )
{
	pixbeginevent( "PlayerKilled assists" );
				
	if ( isdefined( self.attackers ) )
	{
		for ( j = 0; j < self.attackers.size; j++ )
		{
			player = self.attackers[j];
			
			if ( !isdefined( player ) )
				continue;
			
			if ( player == attacker )
				continue;
				
			if ( player.team != lpattackteam )
				continue;
			
			damage_done = self.attackerDamage[player.clientId].damage;
			player thread globallogic_score::processAssist( self, damage_done, self.attackerDamage[player.clientId].weapon );
		}
	}
	
	if ( level.teamBased )
	{
		self globallogic_score::processKillstreakAssists( attacker, eInflictor, weapon );
	}
	
	if ( isdefined( self.lastAttackedShieldPlayer ) && isdefined( self.lastAttackedShieldTime ) && self.lastAttackedShieldPlayer != attacker )
	{
		if ( gettime() - self.lastAttackedShieldTime < 4000 )
		{
			self.lastAttackedShieldPlayer thread globallogic_score::processShieldAssist( self );
		}
	}

	pixendevent(); //"END: PlayerKilled assists" 
}

function PlayerKilled_Kill( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc )
{
	globallogic_score::incTotalKills(attacker.team);
	
	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
	{
		if( isdefined( eInflictor ) && ( isdefined( eInflictor.teamops ) && eInflictor.teamops ) )
		{
			globallogic_score::giveTeamScore( "kill", attacker.team, undefined, self );
			return;
		}
	}
	
	attacker thread globallogic_score::giveKillStats( sMeansOfDeath, weapon, self );


	if ( isAlive( attacker ) )
	{
		pixbeginevent("killstreak");

		if ( !isdefined( eInflictor ) || !isdefined( eInflictor.requiredDeathCount ) || attacker.deathCount == eInflictor.requiredDeathCount )
		{
			shouldGiveKillstreak = killstreaks::should_give_killstreak( weapon );
			//attacker thread _properks::earnedAKill();

			if ( shouldGiveKillstreak )
			{
				attacker killstreaks::add_to_killstreak_count( weapon );
			}

			attacker.pers["cur_total_kill_streak"]++;
			attacker setplayercurrentstreak( attacker.pers["cur_total_kill_streak"] );

			//Kills gotten through killstreak weapons should not the players killstreak
			if ( isdefined( level.killstreaks ) &&  shouldGiveKillstreak )
			{	
				attacker.pers["cur_kill_streak"]++;
				
				if ( attacker.pers["cur_kill_streak"] >= 2 ) 
				{
					if ( attacker.pers["cur_kill_streak"] == 10 )
					{
						attacker challenges::killstreakTen();
					}
					if ( attacker.pers["cur_kill_streak"] <= 30 ) 
					{
						scoreevents::processScoreEvent( "killstreak_" + attacker.pers["cur_kill_streak"], attacker, self, weapon );
					}
					else
					{
						scoreevents::processScoreEvent( "killstreak_more_than_30", attacker, self, weapon );
					}
				}

				if ( !isdefined( level.usingMomentum ) || !level.usingMomentum )
				{
					if( GetDvarInt( "teamOpsEnabled" ) == 0 )
						attacker thread killstreaks::give_for_streak();
				}
			}
		}
	
		if( isPlayer( attacker ) )
			self thread battlechatter::on_player_killstreak( attacker );

		pixendevent(); // "killstreak"
	}

	if ( attacker.pers["cur_kill_streak"] > attacker.kill_streak )
	{
		if ( level.rankedMatch && !level.disableStatTracking ) 
		{
			attacker setDStat( "HighestStats", "kill_streak", attacker.pers["totalKillstreakCount"] );
		}
		attacker.kill_streak = attacker.pers["cur_kill_streak"];
	}
	

	if ( attacker.pers["cur_kill_streak"] > attacker.gametype_kill_streak )
	{
		attacker persistence::stat_set_with_gametype( "kill_streak", attacker.pers["cur_kill_streak"] );
		attacker.gametype_kill_streak = attacker.pers["cur_kill_streak"];
	}
	
	killstreak = killstreaks::get_killstreak_for_weapon( weapon );

	if ( isdefined( killstreak ) )
	{
		if ( scoreevents::isRegisteredEvent( killstreak ) )
		{
			scoreevents::processScoreEvent( killstreak, attacker, self, weapon );
		}
		
		if( weapon.name == "straferun_gun" || weapon.name == "straferun_rockets")
		{
			if( GetDvarInt( "teamOpsEnabled" ) == 1 )
				einflictor straferun::addStraferunKill();
			else
				attacker straferun::addStraferunKill();
		}
	}
	else
	{
		if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) && level.gameType == "gun" )
		{
			// do not give the kill event
		}
		else
		{	
			if( ( weapon.name != "helicopter_gunner_turret_primary" ) && 
				( weapon.name != "helicopter_gunner_turret_secondary" ) && 
				( weapon.name != "helicopter_gunner_turret_tertiary" ) ) // TODO move this throught the killstreak alt weapon functionality
			{
				scoreevents::processScoreEvent( "kill", attacker, self, weapon );
				if ( globallogic::isTopScoringPlayer( self ) )
					scoreevents::processScoreEvent( "killed_leader", attacker, self, weapon );
			}
		}
		
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
		{
			scoreevents::processScoreEvent( "headshot", attacker, self, weapon );
		}
		else if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) )
		{		
			scoreevents::processScoreEvent( "melee_kill", attacker, self, weapon );
		}
	}

	attacker thread  globallogic_score::trackAttackerKill( self.name, self.pers["rank"], self.pers["rankxp"], self.pers["prestige"], self getXuid(true) );	
	
	attackerName = attacker.name;
	self thread  globallogic_score::trackAttackeeDeath( attackerName, attacker.pers["rank"], attacker.pers["rankxp"], attacker.pers["prestige"], attacker getXuid(true) );
	self thread medals::setLastKilledBy( attacker );

	attacker thread  globallogic_score::incKillstreakTracker( weapon );
	
	// to prevent spectator gain score for team-spectator after throwing a granade and killing someone before he switched
	if ( level.teamBased && attacker.team != "spectator")
	{
		globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
	}

	scoreSub = level.deathPointLoss;
	if ( scoreSub != 0 )
	{
		globallogic_score::_setPlayerScore( self, globallogic_score::_getPlayerScore( self ) - scoreSub );
	}
	
	level thread playKillBattleChatter( attacker, weapon, self, eInflictor );
}

function Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	profilelog_begintiming( 7, "ship" );
	
	self endon( "spawned" );
	self notify( "killed_player" );
	self callback::callback( #"on_player_killed" );

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
	self.teamKilled = false;
	
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
	
	self thread globallogic_audio::flush_group_dialog_on_player( "item_destroyed" );
	
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
			
			//self thread battlechatter::perk_specific_battle_chatter( "secondchance" );
			
			if ( isdefined( self.previousPrimary ) )
			{
				wasInLastStand = true;
				lastWeaponBeforeDroppingIntoLastStand = self.previousPrimary;
			}
		}
		self.lastStandParams = undefined;
	}

	self StopSounds();
	
	bestPlayer = undefined;
	bestPlayerMeansOfDeath = undefined;
	obituaryMeansOfDeath = undefined;
	bestPlayerWeapon = undefined;
	obituaryWeapon = weapon;
	assistedSuicide = false;
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
			scoreevents::processScoreEvent( "assisted_suicide", bestPlayer, self, weapon );
			self RecordKillModifier("assistedsuicide");
			assistedSuicide = true;
		}
	}
	
	if ( isdefined ( bestPlayer ) )
	{
		attacker = bestPlayer;
		obituaryMeansOfDeath = bestPlayerMeansOfDeath;
		obituaryWeapon = bestPlayerWeapon;
		if ( isdefined( bestPlayerWeapon ) )
		{
			weapon = bestPlayerWeapon;
		}
	}

	if ( isplayer( attacker ) )
		attacker.damagedPlayers[self.clientid] = undefined;

	globallogic::DoWeaponSpecificKillEffects(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
	
	self.deathTime = getTime();
		
	attacker = updateAttacker( attacker, weapon );
	eInflictor = updateInflictor( eInflictor );

	sMeansOfDeath = self PlayerKilled_UpdateMeansOfDeath( attacker, eInflictor, weapon, sMeansOfDeath, sHitLoc );
	
	if ( !isdefined( obituaryMeansOfDeath ) ) 
		obituaryMeansOfDeath = sMeansOfDeath;

//	if ( isdefined(self.hasRiotShieldEquipped) && (self.hasRiotShieldEquipped==true) )
	{
//		self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
		self.hasRiotShield = false;
		self.hasRiotShieldEquipped = false;
	}

	self thread updateGlobalBotKilledCounter();

	self PlayerKilled_WeaponStats( attacker, weapon, sMeansOfDeath, wasInLastStand, lastWeaponBeforeDroppingIntoLastStand, eInflictor );
	
	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
	{
		if( !( isdefined( eInflictor ) && ( isdefined( eInflictor.teamops ) && eInflictor.teamops ) ) )
		{
			self PlayerKilled_Obituary( attacker, eInflictor, obituaryWeapon, obituaryMeansOfDeath );
		}
		else
		{
			self PlayerKilled_Obituary( eInflictor, eInflictor, obituaryWeapon, obituaryMeansOfDeath );
		}
	}
	else
	{
		self PlayerKilled_Obituary( attacker, eInflictor, obituaryWeapon, obituaryMeansOfDeath );
	}
	

	spawnlogic::death_occured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;
	
	self.killedPlayersCurrent = [];
	
	self.deathCount++;

/#
	println( "players("+self.clientId+") death count ++: " + self.deathCount );
#/

	self PlayerKilled_Killstreaks( attacker, weapon );
		
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
	wasTeamKill = false;
	wasSuicide = false;
	
	pixendevent(); // "PlayerKilled pre constants" );

	scoreevents::processScoreEvent( "death", self, self, weapon );
	self.pers["resetMomentumOnSpawn"] = true;

	if( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackteam = attacker.team;
		lpattackorigin = attacker.origin;

		if ( attacker == self || assistedSuicide == true ) // killed himself
		{
			doKillcam = false;
			wasSuicide = true;
			
			awardAssists = self PlayerKilled_Suicide( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc );
		}
		else
		{
			pixbeginevent( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;
	
			if ( level.teamBased && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
			{		
			}
			else if ( level.teamBased && self.team == attacker.team ) // killed by a friendly
			{
				wasTeamKill = true;
			
				self PlayerKilled_TeamKill( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc );
			}
			else
			{
				self PlayerKilled_Kill( eInflictor, attacker, sMeansOfDeath, weapon, sHitLoc );
					
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
		
		thread scoreevents::processScoreEvent( "suicide", self );
		self globallogic_score::incPersStat( "suicides", 1 );
		self.suicides = self  globallogic_score::getPersStat( "suicides" );
		
		self.suicide = true;
		
		//Check for player death related battlechatter
		thread battlechatter::on_player_suicide_or_team_kill( self, "suicide" );	//Play suicide battlechatter

		//check if assist points should be awarded
		awardAssists = true;

		if ( level.maxSuicidesBeforeKick > 0 && level.maxSuicidesBeforeKick <= self.suicides )
		{
			// should change "teamKillKicked" to just kicked for the next game
			self notify( "teamKillKicked" );
			self SuicideKick();
		}
	}
	else
	{
		doKillcam = false;
		
		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackteam = "world";

		wasSuicide = true;
		
		// we may have a killcam on an world entity like the rocket in cosmodrome
		if ( isdefined( eInflictor ) && isdefined( eInflictor.killCamEnt ) )
		{
			doKillcam = true;
			lpattacknum = self getEntityNumber();
			wasSuicide = false;
		}

		// even if the attacker isn't a player, it might be on a team
		if ( isdefined( attacker ) && isdefined( attacker.team ) && ( isdefined( level.teams[attacker.team] ) ) )
		{
			if ( attacker.team != self.team ) 
			{
				if ( level.teamBased )
					globallogic_score::giveTeamScore( "kill", attacker.team, attacker, self );
		
				wasSuicide = false;
			}
		}
		
		//check if assist points should be awarded
		awardAssists = true;
	}	
	
	if ( !level.inGracePeriod )
	{
		if ( sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH" && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_EXPLOSIVE_SPLASH" && sMeansOfDeath != "MOD_PROJECTILE_SPLASH" ) 
		{
			if ( weapon.name != "incendiary_fire" )
			{
				self weapons::drop_scavenger_for_death( attacker );
			}
		}
			
		// to avoid exploits dont allow weapon drops on suicide or teamkills.
		if ( !wasTeamKill && !wasSuicide )
		{
			self weapons::drop_for_death( attacker, weapon, sMeansOfDeath );
		}
	}

	if( SessionModeIsZombiesGame() )
	{
		awardAssists = false;
	}
	
	//award assist points if needed
	if( awardAssists )
	{
		self PlayerKilled_AwardAssists( eInflictor, attacker, weapon, lpattackteam );
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
		isusingheropower = 0;
			
		if ( attacker ability_player::is_using_any_gadget() )
			isusingheropower = 1;
			
		if( killstreaks::is_killstreak_weapon( weapon ) )
		{
			killstreak = killstreaks::get_killstreak_for_weapon( weapon );
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d killstreak %s",
			           gettime(), getplayerspawnid( attacker ), weapon.name, lpattackorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1, isusingheropower, killstreak );
		}
		else
		{
			bbPrint( "mpattacks", "gametime %d attackerspawnid %d attackerweapon %s attackerx %d attackery %d attackerz %d victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d",
			           	gettime(), getplayerspawnid( attacker ), weapon.name, lpattackorigin, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1, isusingheropower );
		}
	}
	else
	{
		bbPrint( "mpattacks", "gametime %d attackerweapon %s victimspawnid %d victimx %d victimy %d victimz %d damage %d damagetype %s damagelocation %s death %d isusingheropower %d",
			           gettime(), weapon.name, getplayerspawnid( self ), self.origin, iDamage, sMeansOfDeath, sHitLoc, 1, 0 );
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

	pixendevent(); //"END: PlayerKilled post constants" 

	pixbeginevent( "PlayerKilled body and gibbing" );
	vAttackerOrigin = undefined;
	if ( isdefined( attacker ) )
	{
		vAttackerOrigin = attacker.origin;
	}
	
	ragdoll_now = false;
	if( isdefined(self.usingvehicle) && self.usingvehicle && isdefined(self.vehicleposition) && self.vehicleposition == 1 )
	{
		ragdoll_now = true;
	}

	//gibbing must kill the player since they put them in ragdoll
	if ( weapon.doGibbing  )
	{
		ragdoll_now = true;
	}

	deathFromAbove = false;
	if( !attacker isOnGround() && sMeansOfDeath == "MOD_MELEE_ASSASSINATE" )
	{
		deathFromAbove = true;
	}
	
	body = self clonePlayer( deathAnimDuration );
	if ( isdefined( body ) )
	{
		self createDeadBody( iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_now, body, deathFromAbove );
		
		self battlechatter::play_death_vox( body, attacker, sMeansOfDeath );
		
		globallogic::DoWeaponSpecificCorpseEffects(body, eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
	}

	pixendevent();// "END: PlayerKilled body and gibbing" 

	thread globallogic_spawn::spawnQueuedClient( self.team, attacker );
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( isdefined( level.teamopsOnPlayerKilled ) )
	{
		self [[level.teamopsOnPlayerKilled]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}

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
	
	// record the kill cam values for the final kill cam
	if ( wasTeamKill == false && assistedSuicide == false && sMeansOfDeath != "MOD_SUICIDE" && !( !isdefined( attacker ) || attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" || attacker == self || isdefined ( attacker.disableFinalKillcam ) ) )
	{
		level thread killcam::record_settings( lpattacknum, self getEntityNumber(), weapon, self.deathTime, deathTimeOffset, psOffsetTime, killcamentityindex, killcamentitystarttime, perks, killstreaks, attacker );
	}

	// let the player watch themselves die
	wait ( 0.25 );

	//check if killed by a sniper
	weaponClass = util::getWeaponClass( weapon );
	if( isdefined( weaponClass ) && weaponClass == "weapon_sniper" )
	{
		self thread battlechatter::killed_by_sniper( attacker );
	}
	else
	{
		self thread battlechatter::player_killed( attacker );
	}	
	self.cancelKillcam = false;
	self thread killcam::cancel_on_use();

	// initial death cam 
	
	defaultPlayerDeathWatchTime = 1.75;
	if ( sMeansOfDeath == "MOD_MELEE_ASSASSINATE" )
	{
		defaultPlayerDeathWatchTime = (deathAnimDuration * 0.001) + 0.5;
	}
	
	if ( isdefined ( level.overridePlayerDeathWatchTimer ) ) 
	{
		defaultPlayerDeathWatchTime = [[level.overridePlayerDeathWatchTimer]]( defaultPlayerDeathWatchTime );
	}
	
	globallogic_utils::waitForTimeOrNotify( defaultPlayerDeathWatchTime, "end_death_delay" );

	self notify ( "death_delay_finished" );
	
	// killcam 
	
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
//		level thread killcam::startFinalKillcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, weapon, self.deathTime, deathTimeOffset, psOffsetTime, perks, killstreaks, attacker );
		return;
	}
	
	self.respawnTimerStartTime = gettime();
	keep_deathcam = false; 
	if ( isdefined(	self.overridePlayerDeadStatus ) )
	{
		keep_deathcam = self [[ self.overridePlayerDeadStatus ]]();
	}
	
	if ( !self.cancelKillcam && doKillcam && level.killcam )
	{
		livesLeft = !(level.numLives && !self.pers["lives"]);
		timeUntilSpawn =  globallogic_spawn::TimeUntilSpawn( true );
		willRespawnImmediately = livesLeft && (timeUntilSpawn <= 0) && !level.playerQueuedRespawn;
			
		self killcam::killcam( lpattacknum, self getEntityNumber(), killcamentity, killcamentityindex, killcamentitystarttime, weapon, self.deathTime, deathTimeOffset, psOffsetTime, willRespawnImmediately, globallogic_utils::timeUntilRoundEnd(), perks, killstreaks, attacker, keep_deathcam );
	}

	// secondary deathcam for resurrection
	
	secondary_deathcam = 0.0;
	
	timeUntilSpawn =  globallogic_spawn::TimeUntilSpawn( true );
	shouldDoSecondDeathCam = timeUntilSpawn > 0;
	
	if ( shouldDoSecondDeathCam && IsDefined(self.secondaryDeathCamTime) )
	{
		secondary_deathcam = self [[self.secondaryDeathCamTime]]();
	}
	
	if ( secondary_deathcam > 0.0 && !self.cancelKillcam )
	{
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		globallogic_utils::waitForTimeOrNotify( secondary_deathcam, "end_death_delay" );
		self notify ( "death_delay_finished" );
	}
	
	// secondary deathcam is complete
	
	if ( !self.cancelKillcam && doKillcam && level.killcam && keep_deathcam )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
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
	useRespawnTime = true;
	if( isDefined( level.hostMigrationTimer ) )
	{
		useRespawnTime = false;
	}
	hostmigration::waittillHostMigrationCountDown();
	//if ( isDefined( level.hostMigrationTimer ) )
		//return;

	// class may be undefined if we have changed teams
	if ( globallogic_utils::isValidClass( self.curClass ) )
	{
		timePassed = undefined;
		
		if ( isdefined( self.respawnTimerStartTime ) && useRespawnTime )
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

function SuicideKick()
{
	self  globallogic_score::incPersStat( "sessionbans", 1 );			
	
	self endon("disconnect");
	waittillframeend;
	
	globallogic::gameHistoryPlayerKicked();
	
	ban( self getentitynumber() );
	globallogic_audio::leader_dialog( "kicked" );		
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

	globallogic::gameHistoryPlayerKicked();
	
	ban( self getentitynumber() );
	globallogic_audio::leader_dialog( "kicked" );		
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
	if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) )
		return false;
		
	if ( weapon.ignoreTeamKills )
		return true;
		
	return false;	
}


function Callback_PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	//_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 
}

function damageShellshockAndRumble( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage )
{
	if ( !self util::isUsingRemote() )
	{
		self thread weapons::on_damage( eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage );
		self PlayRumbleOnEntity( "damage_heavy" );
	}
}


function createDeadBody( iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body, deathFromAbove )
{
	if ( sMeansOfDeath == "MOD_HIT_BY_OBJECT" && self GetStance() == "prone" )
	{
		self.body = body;
		if ( !isdefined( self.switching_teams ) )
			thread deathicons::add( body, self, self.team, 5.0 );

		return;
	}

	if ( isdefined( level.ragdoll_override ) && self [[level.ragdoll_override]]( iDamage, sMeansOfDeath, weapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body ) )
	{
		return;
	}

	if ( ( ragdoll_jib ) || self isOnLadder() || self isMantling() || sMeansOfDeath == "MOD_CRUSH" || sMeansOfDeath == "MOD_HIT_BY_OBJECT" )
		body startRagDoll();

	if ( !self IsOnGround() )
	{
		if ( GetDvarint( "scr_disable_air_death_ragdoll" ) == 0 )
		{
			body startRagDoll();
		}
	}

	if( sMeansOfDeath == "MOD_MELEE_ASSASSINATE" && isDefined( deathFromAbove ) && deathFromAbove )
	{
		body start_death_from_above_ragdoll( vDir );
	}

	if ( self is_explosive_ragdoll( weapon, eInflictor ) )
	{
		body start_explosive_ragdoll( vDir, weapon );
	}

	thread delayStartRagdoll( body, sHitLoc, vDir, weapon, eInflictor, sMeansOfDeath );

	if ( sMeansOfDeath == "MOD_CRUSH" )
	{
		body globallogic_vehicle::vehicleCrush();
	}
	
	self.body = body;
	if ( !isdefined( self.switching_teams ) )
		thread deathicons::add( body, self, self.team, 5.0 );
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

	if ( isdefined( weapon ) && (weapon.name == "sticky_grenade" || weapon.name == "explosive_bolt") )
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

function start_death_from_above_ragdoll( dir )
{
	if ( !isdefined( self ) )
	{
		return;
	}

	self StartRagdoll();
	self LaunchRagdoll( ( 0, 0, -100 ) );
}


function notifyConnecting()
{
	waittillframeend;

	if( isdefined( self ) )
	{
		level notify( "connecting", self );
	}
	
	callback::callback( #"on_player_connecting" );
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
	
	waittillframeend;
	
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
	
	//waitTime -= 0.2; // account for the wait above
	if( waitTime > 0 )
		wait( waitTime );

	if ( isdefined( ent ) )
	{
		ent startragdoll();
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

function PlayerKilled_UpdateMeansOfDeath( attacker, eInflictor, weapon, sMeansOfDeath, sHitLoc )
{
	if( globallogic_utils::isHeadShot( weapon, sHitLoc, sMeansOfDeath, eInflictor ) && isPlayer( attacker ) && !weapon_utils::ismeleemod( sMeansOfDeath ) )
	{
		return "MOD_HEAD_SHOT";
	}
	
	// we do not want the melee icon to show up for dog attacks
	switch( weapon.name )
	{
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

	if( isdefined( attacker ) && isdefined( weapon ) && (weapon.name == "straferun_rockets" || weapon.name == "straferun_gun") )
	{
		if( isdefined( attacker.strafeRunbda ) )
		{
			attacker.strafeRunbda++;
		}
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
	
	if ( weapon.name == "hero_gravityspikes" )
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
	
function playKillBattleChatter( attacker, weapon, victim, eInflictor )
{
	if( IsPlayer( attacker ) )
	{
		if ( !killstreaks::is_killstreak_weapon( weapon ) )
		{
			level thread battlechatter::say_kill_battle_chatter( attacker, weapon, victim );
		}
	}
	
	if( isdefined( eInflictor ) )
	{
		eInflictor notify( "bhtn_action_notify", "attack_kill" );
	}
}
