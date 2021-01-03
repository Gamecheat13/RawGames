#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\util_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\tweakables_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;


    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_battlechatter;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_deathicons;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_dev;
#using scripts\cp\gametypes\_friendicons;
#using scripts\cp\gametypes\_globallogic_defaults;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_healthoverlay;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_killcam;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_menus;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_persistence;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_save;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_scoreboard;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_serversettings;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_shellshock;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_spawnlogic;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_spectating;//DO NOT REMOVE - needed for system registration
#using scripts\cp\gametypes\_wager;
#using scripts\cp\gametypes\_weapons;//DO NOT REMOVE - needed for system registration

#using scripts\cp\_bb;//DO NOT REMOVE - needed for system registration
#using scripts\shared\_burnplayer;
#using scripts\cp\_challenges;
#using scripts\cp\_decoy;//DO NOT REMOVE - needed for system registration
#using scripts\cp\_gameadvertisement;
#using scripts\cp\_gamerep;
#using scripts\cp\_laststand;
#using scripts\cp\_load;
#using scripts\cp\_rat;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_killstreak_weapons;
#using scripts\cp\killstreaks\_killstreaks;//DO NOT REMOVE - needed for system registration
#using scripts\cp\teams\_teams;//DO NOT REMOVE - needed for system registration

// must match the stats.ddl quitTypes_e enum



	
#namespace globallogic;

#precache( "model", "script_origin" );
#precache( "model", "tag_origin" );

#precache( "statusicon", "hud_status_dead" );
#precache( "statusicon", "hud_status_connecting" );

#precache( "material", "white" );
#precache( "material", "black" );

#precache( "string", "PLATFORM_PRESS_TO_SPAWN" );
#precache( "string", "MP_WAITING_FOR_TEAMS" );
#precache( "string", "MP_OPPONENT_FORFEITING_IN" );
#precache( "string", "MP_WAITING_FOR_PLAYERS" );
#precache( "string", "MP_OPPONENT_FORFEITING_IN" );
#precache( "string", "MP_MATCH_STARTING_IN" );
#precache( "string", "COOP_SPAWN_NEXT_ROUND" );
#precache( "string", "MP_WAITING_TO_SPAWN" );
#precache( "string", "MP_WAITING_TO_SPAWN_SS" );
//#precache( "string", "MP_WAITING_TO_SAFESPAWN" );
#precache( "string", "MP_YOU_WILL_RESPAWN" );
#precache( "string", "MP_MATCH_STARTING" );
#precache( "string", "MP_CHANGE_CLASS_NEXT_SPAWN" );
#precache( "string", "MPUI_LAST_STAND" );
#precache( "string", "PLATFORM_COWARDS_WAY_OUT" );
#precache( "string", "MP_MATCH_TIE" );
#precache( "string", "MP_ROUND_DRAW" );
#precache( "string", "MP_ENEMIES_ELIMINATED" );
#precache( "string", "MP_SCORE_LIMIT_REACHED" );
#precache( "string", "MP_ROUND_LIMIT_REACHED" );
#precache( "string", "MP_TIME_LIMIT_REACHED" );
#precache( "string", "MP_PLAYERS_FORFEITED" );
#precache( "string", "MP_OTHER_TEAMS_FORFEITED" );

function init()
{	
	level.splitscreen = isSplitScreen();
	level.xenon = (GetDvarString( "xenonGame") == "true");
	level.ps3 = (GetDvarString( "ps3Game") == "true");
	level.wiiu = (GetDvarString( "wiiuGame") == "true");
	level.orbis = (GetDvarString( "orbisGame") == "true");
	level.durango = (GetDvarString( "durangoGame") == "true");
	
	level.isCP       = true;
	level.isMP       = false;
	level.isZM       = false;

	level.onlineGame = SessionModeIsOnlineGame();
	level.systemLink = SessionModeIsSystemlink(); 
	level.console = (level.xenon || level.ps3 || level.wiiu || level.orbis || level.durango);
	
	level.rankedMatch = ( GameModeIsUsingXP() );
	level.leagueMatch = false;
	level.arenaMatch = false;
	
	level.contractsEnabled = !GetGametypeSetting( "disableContracts" );
		
	level.contractsEnabled = false;
		
	/#
	if ( GetDvarint( "scr_forcerankedmatch" ) == 1 )
	{
		level.rankedMatch = true;
	}
	#/

	level.script = toLower( GetDvarString( "mapname" ) );
	level.gametype = toLower( GetDvarString( "g_gametype" ) );

	level.teamBased = false;
	level.teamCount = GetGametypeSetting( "teamCount" );
	level.multiTeam = ( level.teamCount > 2 );
	
	level.enemy_ai_team_index = level.teamCount + 1;
	if ( 2 == level.enemy_ai_team_index )
	{
		level.enemy_ai_team = "axis";
	}
	else
	{
		level.enemy_ai_team = "team" + level.enemy_ai_team_index;
	}
	

	// used to loop through all valid playing teams ( not spectator )
	// can also be used to check if a team is valid ( isdefined( level.teams[team] ) )
	// NOTE: added in the same order they are defined in code
	level.teams = [];
	level.teamIndex = [];
	// These are the teams that need player spawn points 
	level.playerteams = []; 
	
	teamCount = level.teamCount;
	
	level.playerteams[ "allies" ] = "allies";
	level.teams[ "allies" ] = "allies";
	level.teams[ "axis" ] = "axis";

	level.teamIndex[ "neutral" ] = 0; // Neutral team set to 0 so that it can be used by objectives
	level.teamIndex[ "allies" ] = 1;
	level.teamIndex[ "axis" ] = 2;
	
	for( teamIndex = 3; teamIndex <= teamCount; teamIndex++ )
	{
		level.teams[ "team" + teamIndex ] = "team" + teamIndex;
		level.teamIndex[ "team" + teamIndex ] = teamIndex;
	}
	
	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	level.displayHalftimeText = false;
	level.displayRoundEndText = true;
	
	level.endGameOnScoreLimit = true;
	level.endGameOnTimeLimit = true;
	level.cumulativeRoundScores = true;
	level.scoreRoundWinBased = false;
	level.resetPlayerScoreEveryRound = false;
	
	level.gameForfeited= false;
	level.forceAutoAssign = false;
	
	level.halftimeType = "halftime";
	level.halftimeSubCaption = &"MP_SWITCHING_SIDES_CAPS";
	
	level.lastStatusTime = 0;
	level.wasWinning = [];
	
	level.lastSlowProcessFrame = 0;
	
	level.placement = [];
	foreach( team in level.teams )
	{
		level.placement[team] = [];
	}
	level.placement["all"] = [];
	
	level.postRoundTime = 7.0;//Kevin Sherwood changed to 9 to have enough time for music stingers
	
	level.inOvertime = false;
	
	level.defaultOffenseRadius = 560;

	level.dropTeam = GetDvarint( "sv_maxclients" );
	
	level.inFinalKillcam = false;

	globallogic_ui::init();

	registerDvars();
	loadout::initPerkDvars();

	level.oldschool = ( GetDvarint( "scr_oldschool" ) == 1 );
	if ( level.oldschool )
	{
		/#print( "game mode: oldschool" );#/
	
		SetDvar( "jump_height", 64 );
		SetDvar( "jump_slowdownEnable", 0 );
		SetDvar( "bg_fallDamageMinHeight", 256 );
		SetDvar( "bg_fallDamageMaxHeight", 512 );
		SetDvar( "player_clipSizeMultiplier", 2.0 );
	}
	
	precache_mp_leaderboards();
	
	// sets up the flame fx
	//burnplayer::initBurnPlayer();
	
	if ( !isdefined( game["tiebreaker"] ) )
	{
		game["tiebreaker"] = false;
	}
		

	thread gameadvertisement::init();
	thread gamerep::init();
	
	level.disableChallenges = false;
	
	if ( level.leagueMatch || ( GetDvarInt( "scr_disableChallenges" ) > 0 ) )
	{
		level.disableChallenges = true;
	}
	
	level.disableStatTracking = ( GetDvarInt( "scr_disableStatTracking" ) > 0 );
	
	level thread SetupCallbacks();
}

function registerDvars()
{
	if ( GetDvarString( "scr_oldschool" ) == "" )
		SetDvar( "scr_oldschool", "0" );
		
	//makeDvarServerInfo( "scr_oldschool" );

	if ( GetDvarString( "ui_guncycle" ) == "" )
		SetDvar( "ui_guncycle", 0 );
		
	//makeDvarServerInfo( "ui_guncycle" );

	if ( GetDvarString( "ui_weapon_tiers" ) == "" )
		SetDvar( "ui_weapon_tiers", 0 );
	//makeDvarServerInfo( "ui_weapon_tiers" );

	SetDvar( "ui_text_endreason", "");
	//makeDvarServerInfo( "ui_text_endreason", "" );

	setMatchFlag( "bomb_timer", 0 );
	
	setMatchFlag( "enable_popups", 1 );

	if ( GetDvarString( "scr_vehicle_damage_scalar" ) == "" )
		SetDvar( "scr_vehicle_damage_scalar", "1" );
		
	level.vehicleDamageScalar = GetDvarfloat( "scr_vehicle_damage_scalar");

	level.fire_audio_repeat_duration = GetDvarint( "fire_audio_repeat_duration" );
	level.fire_audio_random_max_duration = GetDvarint( "fire_audio_random_max_duration" );

	teamName = getcustomteamname( level.teamIndex[ "allies" ] );
	if( isdefined( teamName ) )
		SetDvar( "g_customTeamName_Allies", teamName );
	else
		SetDvar( "g_customTeamName_Allies", "" );

	teamName = getcustomteamname( level.teamIndex[ "axis" ] );
	if( isdefined( teamName ) )
		SetDvar( "g_customTeamName_Axis", teamName );
	else
		SetDvar( "g_customTeamName_Axis", "" );

}

function blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

function SetupCallbacks()
{
	level.spawnPlayer = &globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = &globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = &globallogic_spawn::spawnClient;
	level.spawnSpectator = &globallogic_spawn::spawnSpectator;
	level.spawnIntermission = &globallogic_spawn::spawnIntermission;
	level.scoreOnGivePlayerScore = &globallogic_score::givePlayerScore;
	level.onPlayerScore = &globallogic_score::default_onPlayerScore;
	level.onTeamScore = &globallogic_score::default_onTeamScore;
	
	level.waveSpawnTimer =&waveSpawnTimer;
	level.spawnMessage =	&globallogic_spawn::default_spawnMessage;
	
	level.onSpawnPlayer =&blank;
	level.onSpawnPlayerUnified =&blank;
	level.onSpawnSpectator = &globallogic_defaults::default_onSpawnSpectator;
	level.onSpawnIntermission = &globallogic_defaults::default_onSpawnIntermission;
	level.onRespawnDelay =&blank;

	level.onForfeit = &globallogic_defaults::default_onForfeit;
	level.onTimeLimit = &globallogic_defaults::default_onTimeLimit;
	level.onScoreLimit = &globallogic_defaults::default_onScoreLimit;
	level.onAliveCountChange = &globallogic_defaults::default_onAliveCountChange;
	level.onDeadEvent = &globallogic_defaults::default_onDeadEvent;
	level.onOneLeftEvent = &globallogic_defaults::default_onOneLeftEvent;
	level.giveTeamScore = &globallogic_score::giveTeamScore;
	level.onLastTeamAliveEvent = &globallogic_defaults::default_onLastTeamAliveEvent;
	level.onLastStandEvent = &globallogic_defaults::default_onLastStandEvent;

	level.getTimePassed = &globallogic_utils::getTimePassed;
	level.getTimeLimit = &globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = &globallogic_defaults::default_getTeamKillPenalty;
	level.getTeamKillScore = &globallogic_defaults::default_getTeamKillScore;

	level.isKillBoosting = &globallogic_score::default_isKillBoosting;

	level._setTeamScore = &globallogic_score::_setTeamScore;
	level._setPlayerScore = &globallogic_score::_setPlayerScore;

	level._getTeamScore = &globallogic_score::_getTeamScore;
	level._getPlayerScore = &globallogic_score::_getPlayerScore;
	
	level.onPrecacheGametype =&blank;
	level.onStartGameType =&blank;
	level.onPlayerConnect =&blank;
	level.onPlayerDisconnect =&blank;
	level.onPlayerDamage =&blank;
	level.onPlayerKilled =&blank;
	level.onPlayerKilledExtraUnthreadedCBs = []; ///< Array of other CB function pointers
	level.onPlayerBleedout = &blank;	

	//level.onTeamOutcomeNotify = &hud_message::teamOutcomeNotify;
	//level.onOutcomeNotify = &hud_message::outcomeNotify;
	//level.onTeamWagerOutcomeNotify = &hud_message::teamWagerOutcomeNotify;
	//level.onWagerOutcomeNotify = &hud_message::wagerOutcomeNotify;
	level.setMatchScoreHUDElemForTeam = &hud_message::setMatchScoreHUDElemForTeam;
	level.onEndGame =&blank;
	level.onRoundEndGame = &globallogic_defaults::default_onRoundEndGame;
	level.onMedalAwarded =&blank;
	level.dogManagerOnGetDogs = &dogs::dog_manager_get_dogs;

	globallogic_ui::SetupCallbacks();
}

function precache_mp_leaderboards()
{
	if( SessionModeIsZombiesGame() )
		return;

	if( !level.rankedMatch )
		return;

	mapname = GetDvarString( "mapname" );
	
	globalLeaderboards = "LB_MP_GB_XPPRESTIGE LB_MP_GB_SCORE LB_MP_GB_KDRATIO LB_MP_GB_KILLS LB_MP_GB_WINS LB_MP_GB_DEATHS LB_MP_GB_XPMAXPERGAME LB_MP_GB_TACTICALINSERTS LB_MP_GB_TACTICALINSERTSKILLS LB_MP_GB_PRESTIGEXP LB_MP_GB_HEADSHOTS LB_MP_GB_WEAPONS_PRIMARY LB_MP_GB_WEAPONS_SECONDARY";

	careerLeaderboard = "";
	switch( level.gametype )
	{
		case "oic":
		case "gun":
		case "shrp":
		case "sas":
			break;

		default:
			careerLeaderboard = " LB_MP_GB_SCOREPERMINUTE";
			break;
	}

	gamemodeLeaderboard = " LB_MP_GM_" + level.gametype;
	gamemodeLeaderboardExt = " LB_MP_GM_" + level.gametype + "_EXT";

	gamemodeHCLeaderboard = "";
	gamemodeHCLeaderboardExt = "";
	
	hardcoreMode = GetGametypeSetting( "hardcoreMode" ); 

	if ( isdefined( hardcoreMode ) && hardcoreMode ) 
	{
		gamemodeHCLeaderboard = gamemodeLeaderboard + "_HC";
		gamemodeHCLeaderboardExt = gamemodeLeaderboardExt + "_HC";
	}
	
	mapLeaderboard = " LB_MP_MAP_" + getsubstr( mapname, 3, mapname.size ); // strip the MP_ from the map name
		
	precacheLeaderboards( globalLeaderboards + careerLeaderboard + gamemodeLeaderboard + gamemodeLeaderboardExt + gamemodeHCLeaderboard + gamemodeHCLeaderboardExt + mapLeaderboard );

	//test = "LB_MP_GB_XPMAXPERGAME LB_MP_GB_TACTICALINSERTS";
	//precacheLeaderboards( test );
}


function compareTeamByGameStat( gameStat, teamA, teamB, previous_winner_score )
{
	winner = undefined;
	
	if ( teamA == "tie" )
	{
		winner = "tie";
		
		if ( previous_winner_score < game[gameStat][teamB] )
			winner = teamB;
	}
	else if ( game[gameStat][teamA] == game[gameStat][teamB] )
		winner = "tie";
	else if ( game[gameStat][teamB] > game[gameStat][teamA] )
		winner = teamB;
	else
		winner = teamA;
	
	return winner;
}

function determineTeamWinnerByGameStat( gameStat )
{
	teamKeys = GetArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = game[gameStat][winner];
	
	for ( teamIndex = 1; teamIndex < teamKeys.size; teamIndex++ )
	{
		winner = compareTeamByGameStat( gameStat, winner, teamKeys[teamIndex], previous_winner_score);
		
		if ( winner != "tie" )
		{
			previous_winner_score = game[gameStat][winner];
		}	
	}
	
	return winner;
}

function compareTeamByTeamScore( teamA, teamB, previous_winner_score )
{
	winner = undefined;
  teamBScore = [[level._getTeamScore]]( teamB );

	if ( teamA == "tie" )
	{
		winner = "tie";
		
		if ( previous_winner_score < teamBScore )
			winner = teamB;
			
		return winner;
	}
	
  teamAScore = [[level._getTeamScore]]( teamA );

	if ( teamBScore == teamAScore )
		winner = "tie";
	else if ( teamBScore > teamAScore )
		winner = teamB;
	else
		winner = teamA;
		
	return winner;
}

function determineTeamWinnerByTeamScore( )
{
	teamKeys = GetArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = [[level._getTeamScore]]( winner );
	
	for ( teamIndex = 1; teamIndex < teamKeys.size; teamIndex++ )
	{
		winner = compareTeamByTeamScore( winner, teamKeys[teamIndex], previous_winner_score);
		
		if ( winner != "tie" )
		{
			previous_winner_score = [[level._getTeamScore]]( winner );
		}	
	}
	
	return winner;
}

function forceEnd(hostsucks)
{
	level.nextBSPtoload = undefined;
	level.nextBSPgamemode = undefined;
	level.nextBSPLightingState = undefined;

	if (!isdefined(hostsucks))
		hostsucks = false;

	if ( level.hostForcedEnd || level.forcedEnd )
		return;

	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString( "host ended game", winner );
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
		if ( isdefined( winner ) )
			print( "host ended game, win: " + winner.name );
		else
			print( "host ended game, tie" );
		#/
	}
	
	level.forcedEnd = true;
	level.hostForcedEnd = true;
	
	if (hostsucks)
	{
		endString = &"MP_HOST_SUCKS";
	}
	else
	{
		if ( level.splitscreen )
			endString = &"MP_ENDED_GAME";
		else
			endString = &"MP_HOST_ENDED_GAME";
	}
	
	setMatchFlag( "disableIngameMenu", 1 );
	//makeDvarServerInfo( "ui_text_endreason", endString );
	SetDvar( "ui_text_endreason", endString );
	thread endGame( winner, endString );
}

function killserverPc()
{
	if ( level.hostForcedEnd || level.forcedEnd )
		return;
		
	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString( "host ended game", winner );
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
		if ( isdefined( winner ) )
			print( "host ended game, win: " + winner.name );
		else
			print( "host ended game, tie" );
		#/
	}
	
	level.forcedEnd = true;
	level.hostForcedEnd = true;
	
	level.killserver = true;
	
	endString = &"MP_HOST_ENDED_GAME";
	
	
/#
		PrintLn("kill server; ending game\n");
#/

	thread endGame( winner, endString );
}

function atLeastTwoTeams()
{
	valid_count = 0;
	
	foreach ( team in level.teams )
	{ 
		if ( level.playerCount[team] != 0 )
		{
			valid_count++;
		}
	}
	
	if ( valid_count < 2 )
	{
		return false;
	}
	
	return true;
}

function checkIfTeamForfeits( team )
{
	if ( !game["everExisted"][team] )
		return false;
		
	if ( level.playerCount[team] < 1 && totalPlayerCount() > 0 )
	{
		return true;
	}
	
	return false;
}

function checkForForfeit()
{
	forfeit_count = 0;
	valid_team = undefined;
	
	foreach( team in level.teams )
	{
		if ( checkIfTeamForfeits( team ) )
		{
			forfeit_count++;
			
			if ( !level.multiTeam )
			{
				thread [[level.onForfeit]]( team );
				return true;
			}
		}
		else
		{
			valid_team = team;
		}
	}
	
	if ( level.multiTeam && ( forfeit_count == ( level.teams.size - 1 ) ) )
	{
			thread [[level.onForfeit]]( valid_team );
			return true;		
	}
	
	return false;
}

function doSpawnQueueUpdates()
{
	foreach( team in level.teams )
	{
		if ( level.spawnQueueModified[team] ) 
		{
			[[level.onAliveCountChange]]( team );
		}
	}
}

function isTeamAllDead( team )
{
	return  (level.everExisted[team] && !level.aliveCount[team] && !level.playerLives[team] ); 
}

function areAllTeamsDead( )
{
	foreach( team in level.teams )
	{
		// if team was alive and now they are not
		if ( !isTeamAllDead( team ) )
		{	
			return false;
		}
	}
	
	return true;
}

function getLastTeamAlive()
{
	count = 0;
	everExistedCount = 0;
	aliveTeam = undefined;
	foreach( team in level.teams )
	{
		// if team was alive and now they are not
		if ( level.everExisted[team] )
		{
			if ( !isTeamAllDead( team ) )
			{
				aliveTeam = team;
				count++;
			}
			everExistedCount++;
		}
	}
	
	if ( ( everExistedCount > 1 ) && ( count == 1 ) )
	{
		return aliveTeam;
	}
	
	return undefined;
}

function doDeadEventUpdates()
{
	if ( level.teamBased )
	{
		// if all teams were alive and now they are all dead in the same instance
		if ( areAllTeamsDead( ) )
		{
			[[level.onDeadEvent]]( "all" );
			return true;
		}

		if ( !isdefined( level.onDeadEvent ) )
		{
			lastTeamAlive = getLastTeamAlive();
			if ( isdefined( lastTeamAlive ) )
			{
				[[level.onLastTeamAliveEvent]]( lastTeamAlive );
				return true;
			}
		}
		else
		{
			foreach( team in level.teams )
			{
				// if team was alive and now they are not
				if ( isTeamAllDead( team ) )
				{	
					[[level.onDeadEvent]]( team );
					return true;
				}
			}
		}
	}
	else
	{
		// everyone is dead
		if ( (totalAliveCount() == 0) && (totalPlayerLives() == 0) && level.maxPlayerCount > 1 )
		{
			[[level.onDeadEvent]]( "all" );
			return true;;
		}
	}
	
	return false;
}

function isOnlyOneLeftAliveOnTeam( team )
{
	return  (level.lastAliveCount[team] > 1 && level.aliveCount[team] == 1 && level.playerLives[team] == 1 ); 
}


function doOneLeftEventUpdates()
{
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			// one "team" left
			if ( isOnlyOneLeftAliveOnTeam( team ) )
			{	
				[[level.onOneLeftEvent]]( team );
				return true;;
			}
		}
	}
	else
	{
		// last man standing
		if ( (totalAliveCount() == 1) && (totalPlayerLives() == 1) && level.maxPlayerCount > 1 )
		{
			[[level.onOneLeftEvent]]( "all" );
			return true;;
		}
	}
	
	return false;
}

function isTeamAllLastStand( team )
{
	return  (level.everExisted[team] && (level.aliveCount[team] == level.lastStandCount[team]) ); 
}

function areAllTeamsLastStand( )
{
	foreach( team in level.teams )
	{
		// if team was alive and now they are in last stand
		if ( !isTeamAllLastStand( team ) )
		{	
			return false;
		}
	}
	
	return true;
}

function doLastStandEventUpdates()
{
	if ( !isdefined( level.onLastStandEvent ) )
		return;
		
	if ( level.teamBased )
	{
		// if all teams were alive and now they are all in last stand in the same instance
		if ( areAllTeamsLastStand() )
		{
			[[level.onLastStandEvent]]( "all" );
			return true;
		}

		foreach( team in level.teams )
		{
			// if team was alive and now they are not
			if ( isTeamAllLastStand( team ) )
			{	
				[[level.onLastStandEvent]]( team );
				return true;
			}
		}
	}
	else
	{
		total_last_stand_count = totalLastStandCount();
		// everyone is in laststand
		if ( (total_last_stand_count > 0 ) && (totalAliveCount() == total_last_stand_count ) && level.maxPlayerCount > 1 )
		{
			[[level.onLastStandEvent]]( "all" );
			return true;
		}
	}
	
	return false;
}

function updateGameEvents()
{
/#
	if( GetDvarint( "scr_hostmigrationtest" ) == 1 )
	{
		return;
	}
#/
	if ( ( level.rankedMatch || level.wagerMatch || level.leagueMatch ) && !level.inGracePeriod )
	{
		if ( level.teamBased )
		{
			if (!level.gameForfeited )
			{
				if( game["state"] == "playing" && checkForForfeit() )
				{
					return;
				}
			}
			else // level.gameForfeited==true
			{
				if ( atLeastTwoTeams() )
				{
					level.gameForfeited = false;
					level notify( "abort forfeit" );
				}
			}
		}
		else
		{
			if (!level.gameForfeited)
			{
				if ( totalPlayerCount() == 1 && level.maxPlayerCount > 1 )
				{
					thread [[level.onForfeit]]();
					return;
				}
			}
			else // level.gameForfeited==true
			{
				if ( totalPlayerCount() > 1 )
				{
					level.gameForfeited = false;
					level notify( "abort forfeit" );
				}
			}
		}
	}
		
	if ( !level.playerQueuedRespawn && !level.numLives && !level.inOverTime )
		return;
		
	if ( level.inGracePeriod )
		return;

	if ( level.playerQueuedRespawn )
	{
		doSpawnQueueUpdates();
	}
	
	if ( doDeadEventUpdates() )
		return;
		
	if ( doOneLeftEventUpdates() )
		return;
	
	if ( doLastStandEventUpdates() )
		return;
}


function matchStartTimer()
{	
	visionSetNaked( "mpIntro", 0 );

	matchStartText = hud::createServerFontString( "objective", 1.5 );
	matchStartText hud::setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;

	waitForPlayers();
	matchStartText setText( game["strings"]["match_starting_in"] );

	matchStartTimer = hud::createServerFontString( "big", 2.2 );
	matchStartTimer hud::setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer hud::font_pulse_init();

	countTime = int( level.prematchPeriod );
	
	if ( countTime >= 2 )
	{
		while ( countTime > 0 && !level.gameEnded )
		{
			matchStartTimer setValue( countTime );
			matchStartTimer thread hud::font_pulse( level );
			if ( countTime == 2 )
				visionSetNaked( GetDvarString( "mapname" ), 3.0 );
			countTime--;

			foreach ( player in level.players )
			{
				player PlayLocalSound( "uin_start_count_down" );
			}
			
			wait ( 1.0 );
		}
	}
	else
	{
		visionSetNaked( GetDvarString( "mapname" ), 1.0 );
	}

	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

function matchStartTimerSkip()
{
	visionSetNaked( GetDvarString( "mapname" ), 0 );
}

function notifyTeamWaveSpawn( team, time )
{
	if ( time - level.lastWave[team] > (level.waveDelay[team] * 1000) )
	{
		level notify ( "wave_respawn_" + team );
		level.lastWave[team] = time;
		level.wavePlayerSpawnIndex[team] = 0;
	}
}

function waveSpawnTimer()
{
	level endon( "game_ended" );

	while ( game["state"] == "playing" )
	{
		time = getTime();
		
		foreach( team in level.teams )
		{
			notifyTeamWaveSpawn( team, time );
		}
		{wait(.05);};
	}
}


function hostIdledOut()
{
	hostPlayer = util::getHostPlayer();
	
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return false;
#/

	// host never spawned
	if ( isdefined( hostPlayer ) && !hostPlayer.hasSpawned && !isdefined( hostPlayer.selectedClass ) )
		return true;

	return false;
}

function IncrementMatchCompletionStat( gameMode, playedOrHosted, stat )
{
	self AddDStat( "gameHistory", gameMode, "modeHistory", playedOrHosted, stat, 1 );
}

function SetMatchCompletionStat( gameMode, playedOrHosted, stat )
{
	self SetDStat( "gameHistory", gameMode, "modeHistory", playedOrHosted, stat, 1 );
}

function GetCurrentGameMode()
{
	if( GameModeIsMode( 6 ) )
		return "leaguematch";
		
	return "publicmatch";
}

function getTeamScoreRatio()
{
	playerTeam = self.pers["team"];
	
	score = getTeamScore( playerTeam );
	
	otherTeamScore = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == playerTeam )
			continue;
			
		otherTeamScore += getTeamScore( team );
	}
	
	if ( level.teams.size > 1 )
	{
		otherTeamScore = otherTeamScore / ( level.teams.size - 1 );
	}
	
	if ( otherTeamScore != 0 )
		return ( float( score ) / float( otherTeamScore ) );
		
	// should we just return the flat score here or some other indication of win?
	return score;
}

function getHighestScore()
{
	highestScore = -999999999;
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
		
		if ( player.score > highestScore )
			highestScore = player.score;
	}
	
	return highestScore;
}

function getNextHighestScore( score )
{
	highestScore = -999999999;
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
		
		if ( player.score >= score )
			continue;
			
		if ( player.score > highestScore )
			highestScore = player.score;
	}
	
	return highestScore;
}

function sendAfterActionReport( winner )
{
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1 )
		return;
#/

	if ( !level.isCP && !level.onlineGame )
	{
		return;
	}

	if ( SessionModeIsZombiesGame() )
	{
		return;
	}
		
	//Send After Action Report information to the client
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];

		//Get the kill to death spread of the player
		spread = player.kills - player.deaths;
		
		if( player.pers["cur_kill_streak"] > player.pers["best_kill_streak"] )
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];	
	
		if( level.rankedMatch )
			player persistence::set_after_action_report_stat( "privateMatch", 0 );
		else
			player persistence::set_after_action_report_stat( "privateMatch", 1 );

		player persistence::set_after_action_report_stat( "demoFileID", getDemoFileID() );
		
		if ( isdefined( winner ) && winner ==  player.pers["team"] )
		{
			player persistence::set_after_action_report_stat( "matchWon", true );
		}
		else
		{
			player persistence::set_after_action_report_stat( "matchWon", false );
		}
		
		reviveMaster = 0;
		assistMaster = 0;
		killMaster   = 0;
		
		for ( index = 0; index < level.players.size; index++ )
		{
			player persistence::set_after_action_report_player_stat( index, "isActive", 1 );
			
			player persistence::set_after_action_report_player_stat( index, "name", level.players[index].name );
			player persistence::set_after_action_report_player_stat( index, "xuid", level.players[index] getXuid() );
			
			player persistence::set_after_action_report_player_stat( index, "prvRank", int( level.players[index].pers["rank"] ) );
			player persistence::set_after_action_report_player_stat( index, "curRank", level.players[ index ] GetDStat( "playerstatslist", "rank","StatValue" ) );
			player persistence::set_after_action_report_player_stat( index, "prvXP", int( level.players[index].pers["rankxp"] ) );
			player persistence::set_after_action_report_player_stat( index, "curXP", int( level.players[ index ] GetDStat( "playerstatslist", "rankxp","StatValue" ) ) );
			player persistence::set_after_action_report_player_stat( index, "deaths", level.players[index].deaths );
			
			player persistence::set_after_action_report_player_stat( index, "kills", level.players[index].kills );
		
			if( level.players[index].kills > level.players[killMaster].kills )
			{
				killMaster = index;
			}
				
			player persistence::set_after_action_report_player_stat( index, "assists", level.players[index].assists );
			if( level.players[index].assists > level.players[assistMaster].assists )
			{
				assistMaster = index;
			}
			
			player persistence::set_after_action_report_player_stat( index, "revives", level.players[index].revives );
			if( level.players[index].revives > level.players[reviveMaster].revives )
			{
				reviveMaster = index;
			}
		}
		
		for ( index = 0; index < level.players.size; index++ )
		{
			player persistence::set_after_action_report_player_medal( index, 0, killMaster );   //Kill Master
			player persistence::set_after_action_report_player_medal( index, 1, assistMaster ); //Assist Master
			player persistence::set_after_action_report_player_medal( index, 2, reviveMaster ); //Revive Master
		}

		teamScoreRatio = player getTeamScoreRatio();
		scoreboardPosition = getPlacementForPlayer( player );
		if ( scoreboardPosition < 0 )
		 scoreboardPosition = level.players.size;
		 
		player GameHistoryFinishMatch( 4, player.kills, player.deaths, player.score, scoreboardPosition, teamScoreRatio );
		
		placement = level.placement["all"];			
		for ( otherPlayerIndex = 0; otherPlayerIndex < placement.size; otherPlayerIndex++ )
		{
			if ( level.placement["all"][otherPlayerIndex] == player )
			{
				recordPlayerStats( player, "position", otherPlayerIndex );				
			}				
		}
		
		player persistence::set_after_action_report_stat( "valid", 1 );
		player persistence::set_after_action_report_stat( "viewed", 0 );
			
		if ( isdefined( player.pers["matchesPlayedStatsTracked"] ) )
		{
			gameMode = GetCurrentGameMode();
			player IncrementMatchCompletionStat( gameMode, "played", "completed" );
				
			if ( isdefined( player.pers["matchesHostedStatsTracked"] ) )
			{
				player IncrementMatchCompletionStat( gameMode, "hosted", "completed" );
				player.pers["matchesHostedStatsTracked"] = undefined;
			}
			
			player.pers["matchesPlayedStatsTracked"] = undefined;
		}

		recordPlayerStats( player, "highestKillStreak", player.pers["best_kill_streak"] );
		recordPlayerStats( player, "numUavCalled", player killstreaks::get_killstreak_usage("uav_used") );
		recordPlayerStats( player, "numDogsCalleD", player killstreaks::get_killstreak_usage("dogs_used") );
		recordPlayerStats( player, "numDogsKills", player.pers["dog_kills"] );
		
		recordPlayerMatchEnd( player );
		RecordPlayerStats(player, "presentAtEnd", 1 );
	}
}

function gameHistoryPlayerKicked()
{
	teamScoreRatio = self getTeamScoreRatio();
	scoreboardPosition = getPlacementForPlayer( self );
	if ( scoreboardPosition < 0 )
		 scoreboardPosition = level.players.size;
/#
	assert( isdefined( self.kills ) );
	assert( isdefined( self.deaths ) );
	assert( isdefined( self.score ) );
	assert( isdefined( scoreboardPosition ) );
	assert( isdefined( teamScoreRatio ) );
#/
	self GameHistoryFinishMatch( 2, self.kills, self.deaths, self.score, scoreboardPosition, teamScoreRatio );

	if ( isdefined( self.pers["matchesPlayedStatsTracked"] ) )
	{
		gameMode = GetCurrentGameMode();
		self IncrementMatchCompletionStat( gameMode, "played", "kicked" );
				
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}

	UploadStats( self );
	
	// wait until the player recieves the new stats
  wait(1);
}

function gameHistoryPlayerQuit()
{
	teamScoreRatio = self getTeamScoreRatio();
	scoreboardPosition = getPlacementForPlayer( self );
	if ( scoreboardPosition < 0 )
		 scoreboardPosition = level.players.size;

	self GameHistoryFinishMatch( 3, self.kills, self.deaths, self.score, scoreboardPosition, teamScoreRatio );

 	if ( isdefined( self.pers["matchesPlayedStatsTracked"] ) )
	{
		gameMode = GetCurrentGameMode();
		self IncrementMatchCompletionStat( gameMode, "played", "quit" );
			
		if ( isdefined( self.pers["matchesHostedStatsTracked"] ) )
		{
			self IncrementMatchCompletionStat( gameMode, "hosted", "quit" );
			self.pers["matchesHostedStatsTracked"] = undefined;
		}
		
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	
	UploadStats( self );
 	
	if ( !self IsHost() )
	{
		// wait until the player recieves the new stats
		wait(1);
	}
}

function displayRoundEnd( winner, endReasonText )
{
	if ( level.displayRoundEndText )
	{
		if ( level.teamBased )
		{
			if ( winner == "tie" )
			{
				demo::gameResultBookmark( "round_result", level.teamIndex[ "neutral" ], level.teamIndex[ "neutral" ] );
			}
			else
			{
				demo::gameResultBookmark( "round_result", level.teamIndex[ winner ], level.teamIndex[ "neutral" ] );
			}
		}

		setmatchflag( "cg_drawSpectatorMessages", 0 );
		players = level.players;
		for ( index = 0; index < players.size; index++ )
		{
			player = players[index];
			
			if( !util::wasLastRound() )
			{
				player notify( "round_ended" );
			}
			if ( !isdefined( player.pers["team"] ) )
			{
				player [[level.spawnIntermission]]( true );
				continue;
			}
			
			if ( level.wagerMatch )
			{
				if ( level.teamBased )
					player thread [[level.onTeamWagerOutcomeNotify]]( winner, true, endReasonText );
				else
					player thread [[level.onWagerOutcomeNotify]]( winner, endReasonText );
			}
			else
			{
				if ( level.teamBased )
				{
					player thread [[level.onTeamOutcomeNotify]]( winner, true, endReasonText );	
				}
				else
				{
					player thread [[level.onOutcomeNotify]]( winner, true, endReasonText );
				}
			}
	
     	player setClientUIVisibilityFlag( "hud_visible", 0 );
			player setClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
		}
	}

	if ( util::wasLastRound() )
	{
		roundEndWait( level.roundEndDelay, false );
	}
	else
	{
		roundEndWait( level.roundEndDelay, true );
	}
}

function displayRoundSwitch( winner, endReasonText )
{
	switchType = level.halftimeType;
	if ( switchType == "halftime" )
	{
		if ( isdefined( level.nextRoundIsOvertime ) && level.nextRoundIsOvertime )
		{
			switchType = "overtime";
		}
		else
		{
			if ( level.roundLimit )
			{
				if ( (game["roundsplayed"] * 2) == level.roundLimit )
					switchType = "halftime";
				else
					switchType = "intermission";
			}
			else if ( level.scoreLimit )
			{
				if ( game["roundsplayed"] == (level.scoreLimit - 1) )
					switchType = "halftime";
				else
					switchType = "intermission";
			}
			else
			{
				switchType = "intermission";
			}
		}
	}
	
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		if ( !isdefined( player.pers["team"] ) )
		{
			player [[level.spawnIntermission]]( true );
			continue;
		}
		
		if ( level.wagerMatch )
			player thread [[level.onTeamWagerOutcomeNotify]]( switchType, true, level.halftimeSubCaption );
		else
			player thread [[level.onTeamOutcomeNotify]]( switchType, false, level.halftimeSubCaption );
        player setClientUIVisibilityFlag( "hud_visible", 0 );
	}

	roundEndWait( level.halftimeRoundEndDelay, false );
}

function displayGameEnd( winner, endReasonText, endImage )
{
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
	setmatchflag( "cg_drawSpectatorMessages", 0 );

	if ( level.teambased )
	{
		if ( winner == "tie" )
		{
			demo::gameResultBookmark( "game_result", level.teamIndex[ "neutral" ], level.teamIndex[ "neutral" ] );
		}
		else
		{ 
			demo::gameResultBookmark( "game_result", level.teamIndex[ winner ], level.teamIndex[ "neutral" ] );
		}
	}
	// catching gametype, since DM forceEnd sends winner as player entity, instead of string
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
	
		if ( !isdefined( player.pers["team"] ) )
		{
			player [[level.spawnIntermission]]( true );
			continue;
		}
		
		if ( level.teamBased )
		{
			if (IsDefined(level.onTeamOutcomeNotify))
				player thread [[level.onTeamOutcomeNotify]]( winner, false, endReasonText );
		}
		else
		{
			if (IsDefined(level.onOutcomeNotify))
				player thread [[level.onOutcomeNotify]]( winner, false, endReasonText );
		}
		
   		player setClientUIVisibilityFlag( "hud_visible", 0 );
		player setClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
	}
	
	if ( level.teamBased )
	{

		players = level.players;
		for ( index = 0; index < players.size; index++ )
		{
			player = players[index];
			team = player.pers["team"];
		}
	}
	
	if ( isdefined( level.gameEndUICallback ) )
	{
		level thread [[level.gameEndUICallback]]( winner, endReasonText, endImage );
	}
	
	bbPrint( "global_session_epilogs", "reason %s", endReasonText );

	// tagTMR<NOTE>: all round data aggregates that cannot be summed from other tables post-runtime
	// Removed a blackbox print for "mpmatchfacts" from here
	
	roundEndWait( level.postRoundTime, true );
}

function getEndReasonText()
{
	if ( isdefined( level.endReasonText ) )
	{
		return level.endReasonText;
	}
	
	if ( util::hitRoundLimit() || util::hitRoundWinLimit() )
		return  game["strings"]["round_limit_reached"];
	else if ( util::hitScoreLimit() )
		return  game["strings"]["score_limit_reached"];

	if ( level.forcedEnd )
	{
		if ( level.hostForcedEnd )
			return &"MP_HOST_ENDED_GAME";
		else
			return &"MP_ENDED_GAME";
	}
	return game["strings"]["time_limit_reached"];
}

function resetOutcomeForAllPlayers()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player notify ( "reset_outcome" );
	}
}

function startNextRound( winner,	endReasonText )
{
	if ( !util::isOneRound() )
	{
		displayRoundEnd( winner, endReasonText );

		globallogic_utils::executePostRoundEvents();
		
		if ( !util::wasLastRound() )
		{
			if ( checkRoundSwitch() )
			{
				displayRoundSwitch( winner, endReasonText );
			}
			
			if ( isdefined( level.nextRoundIsOvertime ) && level.nextRoundIsOvertime )
			{
				if ( !isdefined( game["overtime_round"] ) )
				{
					game["overtime_round"] = 1;
				}
				else
				{
					game["overtime_round"]++;
				}
			}

			SetMatchTalkFlag( "DeadChatWithDead", level.voip.deadChatWithDead );
			SetMatchTalkFlag( "DeadChatWithTeam", level.voip.deadChatWithTeam );
			SetMatchTalkFlag( "DeadHearTeamLiving", level.voip.deadHearTeamLiving );
			SetMatchTalkFlag( "DeadHearAllLiving", level.voip.deadHearAllLiving );
			SetMatchTalkFlag( "EveryoneHearsEveryone", level.voip.everyoneHearsEveryone );
			SetMatchTalkFlag( "DeadHearKiller", level.voip.deadHearKiller );
			SetMatchTalkFlag( "KillersHearVictim", level.voip.killersHearVictim );
				
			game["state"] = "playing";
			level.allowBattleChatter["bc"] = GetGametypeSetting( "allowBattleChatter" );
			map_restart( true );
			return true;
		}
	}
	return false;
}

	
function setTopPlayerStats( )
{
	if( level.rankedMatch || level.wagerMatch )
	{
		placement = level.placement["all"];
		topThreePlayers = min( 3, placement.size );
			
		for ( index = 0; index < topThreePlayers; index++ )
		{
			if ( level.placement["all"][index].score )
			{
				if ( !index )
				{
					level.placement["all"][index] AddPlayerStatWithGameType( "TOPPLAYER", 1 );
					level.placement["all"][index] notify( "topplayer" );
				}
				else
					level.placement["all"][index] notify( "nottopplayer" );
				
				level.placement["all"][index] AddPlayerStatWithGameType( "TOP3", 1 );
				level.placement["all"][index]  AddPlayerStat( "TOP3ANY", 1 );
				if ( level.hardcoreMode )
				{
					level.placement["all"][index]  AddPlayerStat( "TOP3ANY_HC", 1 );
				}
				if ( level.multiTeam )
				{
					level.placement["all"][index]  AddPlayerStat( "TOP3ANY_MULTITEAM", 1 );
				}
				level.placement["all"][index] notify( "top3" );
			}
		}
		
		for ( index = 3 ; index < placement.size ; index++ )
		{
			level.placement["all"][index] notify( "nottop3" );
			level.placement["all"][index] notify( "nottopplayer" );
		}

		if ( level.teambased ) 
		{		
			foreach ( team in level.teams )
			{
				setTopTeamStats(team);
			}
		}
	}
}

function setTopTeamStats(team)
{
	placementTeam = level.placement[team];
	topThreeTeamPlayers = min( 3, placementTeam.size );
	// should have at least 5 players on the team
	if ( placementTeam.size < 5 )
		return;
		
	for ( index = 0; index < topThreeTeamPlayers; index++ )
	{
		if ( placementTeam[index].score )
		{
			placementTeam[index] AddPlayerStat( "TOP3TEAM", 1 );
			placementTeam[index] AddPlayerStat( "TOP3ANY", 1 );
			if ( level.hardcoreMode )
			{
				placementTeam[index] AddPlayerStat( "TOP3ANY_HC", 1 );
			}
			if ( level.multiTeam )
			{
				placementTeam[index] AddPlayerStat( "TOP3ANY_MULTITEAM", 1 );
			}
			placementTeam[index] AddPlayerStatWithGameType( "TOP3TEAM", 1 );
		}
	}
}

function getGameLength()
{
	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;		
		// cap it at 20 minutes to avoid exploiting
		gameLength = min( gameLength, 1200 );
	}
	else
	{
		gameLength = level.timeLimit * 60;
	}
	
	return gameLength;
}

function endGame( winner, endReasonText, endImage )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" || level.gameEnded )
		return;

	if ( isdefined( level.onEndGame ) )
		[[level.onEndGame]]( winner );

	//This wait was added possibly for wager match issues, but we think is no longer necessary. 
	//It was creating issues with multiple players calling this fuction when checking game score. In modes like HQ,
	//The game score is given to every player on the team that captured the HQ, so when the points are dished out it loops through
	//all players on that team and checks if the score limit has been reached. But since this wait occured before the game["state"]
	//could be set to "postgame" the check score thread would send the next player that reached the score limit into this function,
	//when the following code should only be hit once. If this wait turns out to be needed, we need to try pulling the game["state"] = "postgame";
	//up above the wait.
	//WAIT_SERVER_FRAME;
	
	setMatchFlag( "enable_popups", 0 );

	if ( !isdefined( level.disableOutroVisionSet ) || level.disableOutroVisionSet == false ) 
	{
		visionSetNaked( "mpOutro", 2.0 );
	}
	
	setmatchflag( "cg_drawSpectatorMessages", 0 );
	setmatchflag( "game_ended", 1 );

	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	SetDvar( "g_gameEnded", 1 );
	level.inGracePeriod = false;
	level notify ( "game_ended" );
	level.allowBattleChatter = [];

	foreach( team in level.teams )
	{
		game["lastroundscore"][team] = getTeamScore( team );
	}
	
	if ( !isdefined( game["overtime_round"] ) || util::wasLastRound() ) // Want to treat all overtime rounds as a single round
	{
		game["roundsplayed"]++;
		game["roundwinner"][game["roundsplayed"]] = winner;
	
		if( level.teambased )
		{
			game["roundswon"][winner]++;	
		}
	}

	if ( isdefined( winner ) && ( level.teambased && isdefined( level.teams[winner] ) ) )
	{
		level.finalKillCam_winner = winner;
	}
	else
	{
		level.finalKillCam_winner = "none";
	}
	
	setGameEndTime( 0 ); // stop/hide the timers
	
	updatePlacement();

	updateRankedMatch( winner );
	
	// freeze players
	players = level.players;
	
	newTime = getTime();
	gameLength = getGameLength();
	
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );

	bbGameOver = 0;
	if ( util::isOneRound() || util::wasLastRound() )
	{
		bbGameOver = 1;
	}

	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player globallogic_player::freezePlayerForRoundEnd();
		player thread roundEndDoF( 4.0 );

		player globallogic_ui::freeGameplayHudElems();
		
		// Update weapon usage stats
		player weapons::update_timings( newTime );
		
		player bbPlayerMatchEnd( gameLength, endReasonText, bbGameOver );

		if( ( level.rankedMatch || level.wagerMatch || level.leagueMatch ) && !player IsSplitscreen() )
		{
			if ( level.leagueMatch )
			{
					player setDStat( "AfterActionReportStats", "lobbyPopup", "leaguesummary" );
			}
			else
			{
				if ( isdefined( player.setPromotion ) )
					player setDStat( "AfterActionReportStats", "lobbyPopup", "promotion" );
				else
					player setDStat( "AfterActionReportStats", "lobbyPopup", "summary" );
			}
		}
	}

	music::setmusicstate( "silent" );

// temporarily disabling round end sound call to prevent the final killcam from not having sound
	if ( !level.inFinalKillcam )
	{
//		util::clientNotify( "snd_end_rnd" );
	}

	gamerep::gameRepUpdateInformationForRound();
	thread challenges::roundEnd( winner );

	if ( startNextRound( winner, endReasonText ) )
	{
		return;
	}
	
	///////////////////////////////////////////
	// After this the match is really ending //
	///////////////////////////////////////////

	if( isdefined( level.nextBSPtoload ) )
	{
		level thread load::preload_next_mission();
	}

	if ( !util::isOneRound() )
	{
		if ( isdefined( level.onRoundEndGame ) )
			winner = [[level.onRoundEndGame]]( winner );

		endReasonText = getEndReasonText();
	}

	if ( level.teambased )
	{
		if ( winner == "tie" )
		{
			recordGameResult( "draw" );
		}
		else
		{
			recordGameResult( winner );
		}
	}
	else
	{
		if ( !isDefined( winner ) )
		{
			recordGameResult( "draw" );
		}
		else
		{
			recordGameResult( winner.team );
		}
	}
	
	skillUpdate( winner, level.teamBased );
	recordLeagueWinner( winner );
	
	setTopPlayerStats();
	thread challenges::gameEnd( winner );

	if ( !isdefined( level.skipGameEnd ) || !level.skipGameEnd )
		displayGameEnd( winner, endReasonText, endImage );
	
	if ( util::isOneRound() )
	{
		globallogic_utils::executePostRoundEvents();
	}
		
	level.intermission = true;

	gamerep::gameRepAnalyzeAndReport();
	
	thread sendAfterActionReport( winner );

	//disabled the ingame pause menu from opening after a game ends
	setMatchFlag( "disableIngameMenu", 1 );
	foreach( player in players )
	{
		player closeInGameMenu();
	}
	
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );

	//regain players array since some might've disconnected during the wait above
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		recordPlayerStats( player, "presentAtEnd", 1 );

		player notify ( "reset_outcome" );
		player thread [[level.spawnIntermission]]();
        player setClientUIVisibilityFlag( "hud_visible", 1 );
	}
	
	if ( isdefined ( level.endGameFunction ) )
	{
		level thread [[level.endGameFunction]]();
	}

	players = GetPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] SetClientAmmoCounterHide( true );
		players[i] SetClientMiniScoreboardHide( true );
	}

	//Eckert - Fading out sound
	level notify ( "sfade");
	/#print( "game ended" );#/
	
	if ( !isdefined( level.skipGameEnd ) || !level.skipGameEnd )
		wait 5.0;
	
	if( IsDefined(level.intermission_override_func) )
	{
		[[ level.intermission_override_func ]]();
		level.intermission_override_func = undefined;
	}

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] CameraActivate( false );
	}

	if ( isDefined( level.nextBspToLoad ) )
	{
		/# println( "nextBSPtoload ="+ level.nextBspToLoad );  #/
		level thread load::load_next_mission();
	}
	else
	{
		ExitLevel( false );	//back to lobby
	}

}

function bbPlayerMatchEnd( gameLength, endReasonString, gameOver ) // self == player
{		 
	playerRank = getPlacementForPlayer( self );
	
	totalTimePlayed = 0;
	if ( isdefined( self.timePlayed ) && isdefined( self.timePlayed["total"] ) )
	{
		totalTimePlayed = self.timePlayed["total"];
		if ( totalTimePlayed > gameLength )
		{
			totalTimePlayed = gameLength;
		}
	}

	xuid = self GetXUID();

	// Removed a blackbox print for "mpplayermatchfacts" from here
}

function roundEndWait( defaultDelay, matchBonus )
{
	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isdefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}

	if ( !matchBonus )
	{
		wait ( defaultDelay );
		level notify ( "round_end_done" );
		return;
	}

  	wait ( defaultDelay / 2 );
	level notify ( "give_match_bonus" );
	wait ( defaultDelay / 2 );

	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isdefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}
	
	level notify ( "round_end_done" );
}


function roundEndDOF( time )
{
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}


function checkTimeLimit()
{
	if ( isdefined( level.timeLimitOverride ) && level.timeLimitOverride )
		return;
	
	if ( game["state"] != "playing" )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.timeLimit <= 0 )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.inPrematchPeriod )
	{
		setGameEndTime( 0 );
		return;
	}
	
	if ( level.timerStopped )
	{
		setGameEndTime( 0 );
		return;
	}
	
	if ( !isdefined( level.startTime ) )
		return;
	
	timeLeft = globallogic_utils::getTimeRemaining();
	
	// want this accurate to the millisecond
	setGameEndTime( getTime() + int(timeLeft) );
	
	if ( timeLeft > 0 )
		return;
	
	[[level.onTimeLimit]]();
}

function allTeamsUnderScoreLimit()
{
	foreach ( team in level.teams )
	{
		if ( game["teamScores"][team] >= level.scoreLimit )
			return false;
	}
	
	return true;
}

function checkScoreLimit()
{
	if ( game["state"] != "playing" )
		return false;

	if ( level.scoreLimit <= 0 )
		return false;

	if ( level.teamBased )
	{
		if( allTeamsUnderScoreLimit() )
			return false;
	}
	else
	{
		if ( !isPlayer( self ) )
			return false;

		if ( self.pointstowin < level.scoreLimit )
			return false;
	}

	[[level.onScoreLimit]]();
}


function updateGameTypeDvars()
{
	level endon ( "game_ended" );
	
	while ( game["state"] == "playing" )
	{
		roundlimit = math::clamp( GetGametypeSetting( "roundLimit" ), level.roundLimitMin, level.roundLimitMax );
		if ( roundlimit != level.roundlimit )
		{
			level.roundlimit = roundlimit;
			level notify ( "update_roundlimit" );
		}

		timeLimit = [[level.getTimeLimit]]();
		if ( timeLimit != level.timeLimit )
		{
			level.timeLimit = timeLimit;
			SetDvar( "ui_timelimit", level.timeLimit );
			level notify ( "update_timelimit" );
		}
		thread checkTimeLimit();

		scoreLimit = math::clamp( GetGametypeSetting( "scoreLimit" ), level.scoreLimitMin, level.scoreLimitMax );
		if ( scoreLimit != level.scoreLimit )
		{
			level.scoreLimit = scoreLimit;
			SetDvar( "ui_scorelimit", level.scoreLimit );
			level notify ( "update_scorelimit" );
		}
		thread checkScoreLimit();
		
		// make sure we check time limit right when game ends
		if ( isdefined( level.startTime ) )
		{
			remaining_time = globallogic_utils::getTimeRemaining();
			if ( isdefined(remaining_time) && remaining_time < 3000 )
			{
				wait .1;
				continue;
			}
		}
		wait 1;
	}
}


function removeDisconnectedPlayerFromPlacement()
{
	offset = 0;
	numPlayers = level.placement["all"].size;
	found = false;
	for ( i = 0; i < numPlayers; i++ )
	{
		if ( level.placement["all"][i] == self )
			found = true;
		
		if ( found )
			level.placement["all"][i] = level.placement["all"][ i + 1 ];
	}
	if ( !found )
		return;
	
	level.placement["all"][ numPlayers - 1 ] = undefined;
	assert( level.placement["all"].size == numPlayers - 1 );

	/#
	globallogic_utils::assertProperPlacement();
	#/
	
	updateTeamPlacement();
	
	if ( level.teamBased )
		return;
		
	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers; i++ )
	{
		player = level.placement["all"][i];
		player notify( "update_outcome" );
	}
	
}

function updatePlacement()
{
	
	if ( !level.players.size )
		return;

	level.placement["all"] = [];
	foreach ( player in level.players )
	{
		if ( !level.teambased || isdefined( level.teams[ player.team ] ) )
			level.placement["all"][level.placement["all"].size] = player;
	}
		
	placementAll = level.placement["all"];
	
	if ( level.teamBased )
	{
		for ( i = 1; i < placementAll.size; i++ )
		{
			player = placementAll[i];
			playerScore = player.score;
			for ( j = i - 1; j >= 0 && (playerScore > placementAll[j].score || (playerScore == placementAll[j].score && player.deaths < placementAll[j].deaths)); j-- )
				placementAll[j + 1] = placementAll[j];
			placementAll[j + 1] = player;
		}
	}
	else
	{
		for ( i = 1; i < placementAll.size; i++ )
		{
			player = placementAll[i];
			playerScore = player.pointstowin;
			for ( j = i - 1; j >= 0 && (playerScore > placementAll[j].pointstowin || (playerScore == placementAll[j].pointstowin && player.deaths < placementAll[j].deaths)); j-- )
				placementAll[j + 1] = placementAll[j];
			placementAll[j + 1] = player;
		}
	}
	
	level.placement["all"] = placementAll;
	
	/#
	globallogic_utils::assertProperPlacement();
	#/
	
	updateTeamPlacement();

}	


function updateTeamPlacement()
{
	foreach( team in level.teams )
	{
		placement[team]    = [];
	}
	placement["spectator"] = [];
	
	if ( !level.teamBased )
		return;
	
	placementAll = level.placement["all"];
	placementAllSize = placementAll.size;
	
	for ( i = 0; i < placementAllSize; i++ )
	{
		player = placementAll[i];
		team = player.pers["team"];
		
		placement[team][ placement[team].size ] = player;
	}
	
	foreach( team in level.teams )
	{
		level.placement[team] = placement[team];
	}
}

function getPlacementForPlayer( player )
{
	updatePlacement();

	playerRank = -1;
	placement = level.placement["all"];
	for ( placementIndex = 0; placementIndex < placement.size; placementIndex++ )
	{
		if ( level.placement["all"][placementIndex] == player )
		{
			playerRank = (placementIndex + 1);
			break;
		}				
	}

	return playerRank;
}

function isTopScoringPlayer( player )
{
	topPlayer = false;
	updatePlacement();

	assert( level.placement["all"].size > 0 );
	if ( level.placement["all"].size == 0 )
	{
		return false;
	}
	
	if ( level.teambased ) 
	{
		topScore = level.placement["all"][0].score;
		for ( index = 0; index < level.placement["all"].size; index++ )
		{
			if ( level.placement["all"][index].score == 0 )
			{
				break;
			}
			if ( topScore > level.placement["all"][index].score )
			{
				break;
			}
			if ( self == level.placement["all"][index] )
			{
				topScoringPlayer = true;
				break;
			}
		}
	}
	else
	{
		topScore = level.placement["all"][0].pointsToWin;
		for ( index = 0; index < level.placement["all"].size; index++ )
		{
			if ( level.placement["all"][index].pointsToWin == 0 )
			{
				break;
			}
			if ( topScore > level.placement["all"][index].pointsToWin )
			{
				break;
			}
			if ( self == level.placement["all"][index] )
			{
				topPlayer = true;
				break;
			}
		}
	}
	return topPlayer;
}

function sortDeadPlayers( team )
{
	// only need to sort if we are running queued respawn
	if ( !level.playerQueuedRespawn )
		return;
		
	// sort by death time
	for ( i = 1; i < level.deadPlayers[team].size; i++ )
	{
		player = level.deadPlayers[team][i];
		for ( j = i - 1; j >= 0 && player.deathTime < level.deadPlayers[team][j].deathTime; j-- )
			level.deadPlayers[team][j + 1] = level.deadPlayers[team][j];
		level.deadPlayers[team][j + 1] = player;
	}
	
	for ( i = 0; i < level.deadPlayers[team].size; i++ )
	{
		if ( level.deadPlayers[team][i].spawnQueueIndex != i )
		{
			level.spawnQueueModified[team] = true;
		}
		level.deadPlayers[team][i].spawnQueueIndex = i;
	}
}

function totalAliveCount()
{
	count = 0;
	foreach( team in level.teams )
	{
		count += level.aliveCount[team];
	}
	return count; 
}

function totalPlayerLives()
{
	count = 0;
	foreach( team in level.teams )
	{
		count += level.playerLives[team];
	}
	return count; 
}

function totalPlayerCount()
{
	count = 0;
	foreach( team in level.teams )
	{
		count += level.playerCount[team];
	}
	return count; 
}

function totalLastStandCount()
{
	count = 0;
	foreach( team in level.teams )
	{
		count += level.lastStandCount[team];
	}
	return count; 
}
function initTeamVariables( team )
{
	if ( !isdefined( level.aliveCount ) )
		level.aliveCount = [];
	
	if ( !isdefined( level.lastStandCount ) )
		level.lastStandCount = [];
	
	level.aliveCount[team] = 0;
	level.lastAliveCount[team] = 0;
	level.lastStandCount[team] = 0;
	
	if ( !isdefined( game["everExisted"] ) )
	{
		game["everExisted"] = [];
	}
	if ( !isdefined( game["everExisted"][team] ) )
	{
		game["everExisted"][team] = false;
	}	
	level.everExisted[team] = false;
	level.waveDelay[team] = 0;
	level.lastWave[team] = 0;
	level.wavePlayerSpawnIndex[team] = 0;

	resetTeamVariables( team );
}

function resetTeamVariables( team )
{
	level.playerCount[team] = 0;
	level.lastAliveCount[team] = level.aliveCount[team];
	level.aliveCount[team] = 0;
	level.lastStandCount[team] = 0;
	level.playerLives[team] = 0;
	level.alivePlayers[team] = [];
	level.deadPlayers[team] = [];
	level.squads[team] = [];
	level.spawnQueueModified[team] = false;
}

function updateTeamStatus()
{
	// run only once per frame, at the end of the frame.
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon ( "game_ended" );
	waittillframeend;
	
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

	if ( game["state"] == "postgame" )
		return;

	resetTimeout();
	
	foreach( team in level.teams )
	{
		resetTeamVariables( team );
	}
	
	level.activePlayers = [];

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if ( !isdefined( player ) && level.splitscreen )
			continue;

		team = player.team;
		playerclass = player.curClass;
		
		if ( team != "spectator" && (isdefined( playerclass ) && playerclass != "") )
		{
			level.playerCount[team]++;
			
			if ( player.sessionstate == "playing" )
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;
				player.spawnQueueIndex = -1;
				
				if ( isAlive( player ) )
				{
					level.alivePlayers[team][level.alivePlayers[team].size] = player;
					level.activeplayers[ level.activeplayers.size ] = player;
					
					if ( isdefined( player.laststand ) && player.laststand )
					{
						level.lastStandCount[team]++;
					}
				}
				else
				{
					level.deadPlayers[team][level.deadPlayers[team].size] = player;
				}
			}
			else
			{
				level.deadPlayers[team][level.deadPlayers[team].size] = player;
				if ( player globallogic_spawn::maySpawn() )
					level.playerLives[team]++;
			}
		}
	}
	
	totalAlive = totalAliveCount();
	
	if ( totalAlive > level.maxPlayerCount )
		level.maxPlayerCount = totalAlive;
	
	foreach( team in level.teams )
	{
		if ( level.aliveCount[team] )
		{
			game["everExisted"][team] = true;
			level.everExisted[team] = true;
		}
	
		sortDeadPlayers( team );
	}

	level updateGameEvents();
}

function checkTeamScoreLimitSoon( team )
{
	assert( isdefined( team ) );
	
	if ( level.scoreLimit <= 0 )
		return;
		
	if ( !level.teamBased )
		return;
		
	// Give the data a minute to converge/settle
	if ( globallogic_utils::getTimePassed() < ( 60 * 1000 ) )
		return;
	
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit( team );
	
	if ( timeLeft < 1 )
	{
		level notify( "match_ending_soon", "score" );
	}
}

function checkPlayerScoreLimitSoon()
{
	assert( IsPlayer( self ) );
	
	if ( level.scoreLimit <= 0 )
		return;
	
	if ( level.teamBased )
		return;
		
	// Give the data a minute to converge/settle
	if ( globallogic_utils::getTimePassed() < ( 60 * 1000 ) )
		return;
		
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit( undefined );
	
	if ( timeLeft < 1 )
	{
		level notify( "match_ending_soon", "score" );
	}
}

function timeLimitClock()
{
	level endon ( "game_ended" );
	
	wait .05;
	
	clockObject = spawn( "script_origin", (0,0,0) );
	
	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped && level.timeLimit )
		{
			timeLeft = globallogic_utils::getTimeRemaining() / 1000;
			timeLeftInt = int(timeLeft + 0.5); // adding .5 and flooring rounds it.
			
			if ( timeLeftInt == 601  )
				util::clientNotify( "notify_10" );
			
			if ( timeLeftInt == 301  )
				util::clientNotify( "notify_5" );
				
			if ( timeLeftInt == 60  )
				util::clientNotify( "notify_1" );
				
			if ( timeLeftInt == 12 )
				util::clientNotify( "notify_count" );
			
			if ( timeLeftInt >= 40 && timeLeftInt <= 60 )
				level notify ( "match_ending_soon", "time" );

			if ( timeLeftInt >= 30 && timeLeftInt <= 40 )
				level notify ( "match_ending_pretty_soon", "time" );
				
			if( timeLeftInt <= 32 )
			    level notify ( "match_ending_vox" );	

			if ( timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0) )
			{
				level notify ( "match_ending_very_soon", "time" );
				// don't play a tick at exactly 0 seconds, that's when something should be happening!
				if ( timeLeftInt == 0 )
					break;
				
				clockObject playSound( "mpl_ui_timer_countdown" );
			}
			
			// synchronize to be exactly on the second
			if ( timeLeft - floor(timeLeft) >= .05 )
				wait timeLeft - floor(timeLeft);
		}

		wait ( 1.0 );
	}
}

function timeLimitClock_Intermission( waitTime )
{
	setGameEndTime( getTime() + int(waitTime*1000) );
	clockObject = spawn( "script_origin", (0,0,0) );
	
	if ( waitTime >= 10.0 )
		wait ( waitTime - 10.0 );
		
	for ( ;; )
	{
		clockObject playSound( "mpl_ui_timer_countdown" );
		wait ( 1.0 );
	}	
}


function startGame()
{
	thread globallogic_utils::gameTimer();
	level.timerStopped = false;
	// RF, disabled this, as it is not required anymore.
	//thread spawnlogic::spawn_per_frame_update();

	SetMatchTalkFlag( "DeadChatWithDead", level.voip.deadChatWithDead );
	SetMatchTalkFlag( "DeadChatWithTeam", level.voip.deadChatWithTeam );
	SetMatchTalkFlag( "DeadHearTeamLiving", level.voip.deadHearTeamLiving );
	SetMatchTalkFlag( "DeadHearAllLiving", level.voip.deadHearAllLiving );
	SetMatchTalkFlag( "EveryoneHearsEveryone", level.voip.everyoneHearsEveryone );
	SetMatchTalkFlag( "DeadHearKiller", level.voip.deadHearKiller );
	SetMatchTalkFlag( "KillersHearVictim", level.voip.killersHearVictim );
	
	if(IsDefined(level.custom_prematch_period))
	{
		[[level.custom_prematch_period]]();
	}	
	else
	{
		prematchPeriod();
	}
	
	level notify("prematch_over");

	thread timeLimitClock();
	thread gracePeriod();
	thread watchMatchEndingSoon();

	recordMatchBegin();
}


function waitForPlayers()
{
	startTime = getTime();

	while ( GetNumConnectedPlayers() < 1 )
	{
		{wait(.05);};
		if( getTime() - startTime > ( 120 * 1000 ) )
		{
			//EOughton: if we've been sitting here for 2 minutes without anyone making it in, it's time to call it a night
			exitLevel( false );			
		}
	}
}	

function prematchPeriod()
{
	setMatchFlag( "hud_hardcore", level.hardcoreMode );

	level endon( "game_ended" );
	
	if ( level.prematchPeriod > 0 )
	{
		thread matchStartTimer();

		waitForPlayers();

		wait ( level.prematchPeriod );
	}
	else
	{
		matchStartTimerSkip();
		
		{wait(.05);};
	}
	
	level.inPrematchPeriod = false;
	
	for ( index = 0; index < level.players.size; index++ )
	{		
		level.players[index] util::freeze_player_controls( false );
		level.players[index] enableWeapons();
	}
	
	wager::prematch_period();

	if ( game["state"] != "playing" )
		return;
}
	
function gracePeriod()
{
	level endon("game_ended");
	
	if ( isdefined( level.gracePeriodFunc ) )
	{
		[[ level.gracePeriodFunc ]]();
	}
	else
	{
		wait ( level.gracePeriod );
	}
	
	level notify ( "grace_period_ending" );
	{wait(.05);};
	
	level.inGracePeriod = false;
	
	if ( game["state"] != "playing" )
		return;
	
	if ( level.numLives )
	{
		// Players on a team but without a weapon show as dead since they can not get in this round
		players = level.players;
		
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( !player.hasSpawned && player.sessionteam != "spectator" && !isAlive( player ) )
				player.statusicon = "hud_status_dead";
		}
	}
	
	level thread updateTeamStatus();
}

function watchMatchEndingSoon()
{
	SetDvar( "xblive_matchEndingSoon", 0 );
	level waittill( "match_ending_soon", reason );
	SetDvar( "xblive_matchEndingSoon", 1 );
}

function anyTeamHasWaveDelay()
{
	foreach ( team in level.teams )
	{
		if ( level.waveDelay[team] )
			return true;
	}
	
	return false;
}

function Callback_StartGameType()
{
	level.prematchPeriod = 0;
	level.intermission = false;

	setmatchflag( "cg_drawSpectatorMessages", 1 );
	setmatchflag( "game_ended", 0 );
	
	if ( !isdefined( game["gamestarted"] ) )
	{
		// defaults if not defined in level script
		if ( !isdefined( game["allies"] ) )
			game["allies"] = "seals";
		if ( !isdefined( game["axis"] ) )
			game["axis"] = "pmc";
		if ( !isdefined( game["attackers"] ) )
			game["attackers"] = "allies";
		if (  !isdefined( game["defenders"] ) )
			game["defenders"] = "axis";

		// if this hits the teams are not setup right
		assert( game["attackers"] != game["defenders"] );
		
		// TODO MTEAM - need to update this valid team
		foreach( team in level.teams )
		{
			if ( !isdefined( game[team] ) )
				game[team] = "pmc";
		}

		if ( !isdefined( game["state"] ) )
			game["state"] = "playing";
	
		//makeDvarServerInfo( "cg_thirdPersonAngle", 354 );

		SetDvar( "cg_thirdPersonAngle", 354 );

		game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";
		if ( level.teamBased )
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		else
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_PLAYERS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["spawn_next_round"] = &"COOP_SPAWN_NEXT_ROUND";
		game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
		game["strings"]["waiting_to_spawn_ss"] = &"MP_WAITING_TO_SPAWN_SS";
		//game["strings"]["waiting_to_safespawn"] = &"MP_WAITING_TO_SAFESPAWN";
		game["strings"]["you_will_spawn"] = &"MP_YOU_WILL_RESPAWN";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
		game["strings"]["last_stand"] = &"MPUI_LAST_STAND";
		
		game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";
		
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";

		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
		game["strings"]["other_teams_forfeited"] = &"MP_OTHER_TEAMS_FORFEITED";

		[[level.onPrecacheGameType]]();

		game["gamestarted"] = true;
		
		game["totalKills"] = 0;

		foreach( team in level.teams )
		{
			game["teamScores"][team] = 0;
			game["totalKillsTeam"][team] = 0;
		}

		level.prematchPeriod = GetGametypeSetting( "prematchperiod" );

		if ( GetDvarint( "xblive_clanmatch" ) != 0 )
		{
			// TODO MTEAM is this code used anymore?
			foreach( team in level.teams )
			{
				game["icons"][team] = "composite_emblem_team_axis";
			}
			
			game["icons"]["allies"] = "composite_emblem_team_allies";
			game["icons"]["axis"] = "composite_emblem_team_axis";
		}
	}
	else
	{
			if ( !level.splitscreen )
				level.prematchPeriod = GetGametypeSetting( "preroundperiod" );
	}

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	SetRoundsPlayed( game["roundsplayed"] );
	
	if ( isdefined( game["overtime_round"] ) )
	{
		SetMatchFlag( "overtime", 1 );
	}
	else
	{
		SetMatchFlag( "overtime", 0 );
	}
	
	if(!isdefined(game["roundwinner"] ))
		game["roundwinner"] = [];

	if(!isdefined(game["lastroundscore"] ))
		game["lastroundscore"] = [];

	if(!isdefined(game["roundswon"] ))
		game["roundswon"] = [];

	if(!isdefined(game["roundswon"]["tie"] ))
		game["roundswon"]["tie"] = 0;

	foreach ( team in level.teams )
	{
		if(!isdefined(game["roundswon"][team] ))
			game["roundswon"][team] = 0;

		level.teamSpawnPoints[team] = [];
		level.spawn_point_team_class_names[team] = [];
	}

	level.skipVote = false;
	level.gameEnded = false;
	SetDvar( "g_gameEnded", 0 );

	level.objIDStart = 0;
	level.forcedEnd = false;
	level.hostForcedEnd = false;

	level.hardcoreMode = GetGametypeSetting( "hardcoreMode" );
	if ( level.hardcoreMode )
	{
		/#print( "game mode: hardcore" );#/
		
		//set up friendly fire delay for hardcore
		if( !isdefined(level.friendlyFireDelayTime) )
			level.friendlyFireDelayTime = 0;
	}

	if ( GetDvarString( "scr_max_rank" ) == "" )
			SetDvar( "scr_max_rank", "0" );
	level.rankCap = GetDvarint( "scr_max_rank" );
	
	if ( GetDvarString( "scr_min_prestige" ) == "" )
	{
		SetDvar( "scr_min_prestige", "0" );
	}
	level.minPrestige = GetDvarint( "scr_min_prestige" );

	level.useStartSpawns = true;

	level.cumulativeRoundScores = GetGametypeSetting( "cumulativeRoundScores" );

	level.allowHitMarkers = GetGametypeSetting( "allowhitmarkers" );
	level.playerQueuedRespawn = GetGametypeSetting( "playerQueuedRespawn" );
	level.playerForceRespawn = GetGametypeSetting( "playerForceRespawn" );

	level.roundStartExplosiveDelay = GetGametypeSetting( "roundStartExplosiveDelay" );
	level.roundStartKillstreakDelay = GetGametypeSetting( "roundStartKillstreakDelay" );
	
	level.perksEnabled = GetGametypeSetting( "perksEnabled" );
	level.disableAttachments = GetGametypeSetting( "disableAttachments" );
	level.disableTacInsert = GetGametypeSetting( "disableTacInsert" );
	level.disableCAC = GetGametypeSetting( "disableCAC" );
	level.disableClassSelection = GetGametypeSetting( "disableClassSelection" );
	level.disableWeaponDrop = GetGametypeSetting( "disableweapondrop" );
	level.onlyHeadShots = GetGametypeSetting( "onlyHeadshots" );
	
	// set to 0 to disable
	level.minimumAllowedTeamKills = GetGametypeSetting( "teamKillPunishCount" ) - 1; // punishment starts at the next one
	level.teamKillReducedPenalty = GetGametypeSetting( "teamKillReducedPenalty" );
	level.teamKillPointLoss = GetGametypeSetting( "teamKillPointLoss" );
	level.teamKillSpawnDelay = GetGametypeSetting( "teamKillSpawnDelay" );
	
	level.deathPointLoss = GetGametypeSetting( "deathPointLoss" );
	level.leaderBonus = GetGametypeSetting( "leaderBonus" );
	level.forceRadar = GetGametypeSetting( "forceRadar" );
	level.playerSprintTime = GetGametypeSetting( "playerSprintTime" );
	level.bulletDamageScalar = GetGametypeSetting( "bulletDamageScalar" );
	
	level.playerMaxHealth = GetGametypeSetting( "playerMaxHealth" );
	level.playerHealthRegenTime = GetGametypeSetting( "playerHealthRegenTime" );
	
	level.playerRespawnDelay = GetGametypeSetting( "playerRespawnDelay" );
	level.playerObjectiveHeldRespawnDelay = GetGametypeSetting( "playerObjectiveHeldRespawnDelay" );
	level.waveRespawnDelay = GetGametypeSetting( "waveRespawnDelay" );
	level.suicideSpawnDelay = GetGametypeSetting( "spawnsuicidepenalty" );
	level.teamKilledSpawnDelay = GetGametypeSetting( "spawnteamkilledpenalty" );
	level.maxSuicidesBeforeKick = GetGametypeSetting( "maxsuicidesbeforekick" );
	
	level.spectateType = GetGametypeSetting( "spectateType" );
	
	level.voip = SpawnStruct();
	level.voip.deadChatWithDead = GetGametypeSetting( "voipDeadChatWithDead" );
	level.voip.deadChatWithTeam = GetGametypeSetting( "voipDeadChatWithTeam" );
	level.voip.deadHearAllLiving = GetGametypeSetting( "voipDeadHearAllLiving" );
	level.voip.deadHearTeamLiving = GetGametypeSetting( "voipDeadHearTeamLiving" );
	level.voip.everyoneHearsEveryone = GetGametypeSetting( "voipEveryoneHearsEveryone" );
	level.voip.deadHearKiller = GetGametypeSetting( "voipDeadHearKiller" );
	level.voip.killersHearVictim = GetGametypeSetting( "voipKillersHearVictim" );
	
	callback::callback( #"on_start_gametype" );

	foreach( team in level.teams )
	{
		initTeamVariables( team );
	}
	
	level.maxPlayerCount = 0;
	level.activePlayers = [];

	level.allowAnnouncer = GetGametypeSetting( "allowAnnouncer" );

	if ( !isdefined( level.timeLimit ) )
		util::registerTimeLimit( 1, 1440 );
		
	if ( !isdefined( level.scoreLimit ) )
		util::registerScoreLimit( 1, 500 );

	if ( !isdefined( level.roundLimit ) )
		util::registerRoundLimit( 0, 10 );

	if ( !isdefined( level.roundWinLimit ) )
		util::registerRoundWinLimit( 0, 10 );
	
	// The order the following functions are registered in are the order they will get called
	globallogic_utils::registerPostRoundEvent( &killcam::post_round_final_killcam );	
	globallogic_utils::registerPostRoundEvent( &wager::post_round_side_bet );

	//makeDvarServerInfo( "ui_scorelimit" );
	//makeDvarServerInfo( "ui_timelimit" );
	//makeDvarServerInfo( "ui_allow_classchange", GetDvarString( "ui_allow_classchange" ) );

	waveDelay = level.waveRespawnDelay;
	if ( waveDelay )
	{
		foreach ( team in level.teams )
		{
			level.waveDelay[team] = waveDelay;
			level.lastWave[team] = 0;
		}
		
		level thread [[level.waveSpawnTimer]]();
	}
	
	level.inPrematchPeriod = true;
	
	if ( level.prematchPeriod > 2.0 )
		level.prematchPeriod = level.prematchPeriod + (randomFloat( 4 ) - 2); // live host obfuscation

	if ( level.numLives || anyTeamHasWaveDelay() || level.playerQueuedRespawn )
		level.gracePeriod = 1500;
	else
		level.gracePeriod = 1500;
		
	level.inGracePeriod = true;
	
	level.roundEndDelay = 5;
	level.halftimeRoundEndDelay = 3;
	
	globallogic_score::updateAllTeamScores();
	
	level.killstreaksenabled = 1;
	
	if ( GetDvarString( "scr_game_rankenabled" ) == "" )
		SetDvar( "scr_game_rankenabled", true );
	level.rankEnabled = GetDvarint( "scr_game_rankenabled" );
	
	if ( GetDvarString( "scr_game_medalsenabled" ) == "" )
		SetDvar( "scr_game_medalsenabled", true );
	level.medalsEnabled = GetDvarint( "scr_game_medalsenabled" );

	if( level.hardcoreMode && level.rankedMatch && GetDvarString( "scr_game_friendlyFireDelay" ) == "" )
		SetDvar( "scr_game_friendlyFireDelay", true );
	level.friendlyFireDelay = GetDvarint( "scr_game_friendlyFireDelay" );

	// level gametype and features globals should be defaulted before this, and level.onstartgametype should reset them if desired
	[[level.onStartGameType]]();

	// disable killstreaks for custom game modes
	if( GetDvarInt( "custom_killstreak_mode" ) == 1 )
	{
		level.killstreaksenabled = 0;
	}
	
	// this must be after onstartgametype for scr_showspawns to work when set at start of game

	level thread killcam::do_final_killcam();

	thread startGame();
	level thread updateGameTypeDvars();
	level thread simple_hostmigration::UpdateHostMigrationData();
	
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1 )
	{
		level.skipGameEnd = true;
		level.roundLimit = 1;
		
		// let things settle
		wait(1);
//		level.forcedEnd = true;
		thread forceEnd( false );
//		thread endgame( "tie","" );
	}
	if( GetDvarint( "scr_hostmigrationtest" ) == 1 )
	{
		thread ForceDebugHostMigration();
	}
#/
}

/#
function ForceDebugHostMigration()
{
	while (1)
	{
		hostmigration::waitTillHostMigrationDone();
		wait(60);
		starthostmigration();
		hostmigration::waitTillHostMigrationDone();
		//thread forceEnd( false );
	}
}
#/

function registerFriendlyFireDelay( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_friendlyFireDelayTime");
	if ( GetDvarString( dvarString ) == "" )
		SetDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		SetDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		SetDvar( dvarString, minValue );

	level.friendlyFireDelayTime = getDvarInt( dvarString );
}

function checkRoundSwitch()
{
	if ( !isdefined( level.roundSwitch ) || !level.roundSwitch )
		return false;
	if ( !isdefined( level.onRoundSwitch ) )
		return false;
	
	assert( game["roundsplayed"] > 0 );
	
	if ( game["roundsplayed"] % level.roundswitch == 0 )
	{
		[[level.onRoundSwitch]]();
		return true;
	}
		
	return false;
}


function listenForGameEnd()
{
	self endon("killGameEndMonitor");
	self waittill( "host_sucks_end_game" );
	
	//if ( level.console )
	//	endparty();
	level.skipVote = true;

	if ( !level.gameEnded )
		level thread globallogic::forceEnd(true);
}


function getKillStreaks( player )
{
	for ( killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++ )
	{
		killstreak[ killstreakNum ] = "killstreak_null";
	}
	
	if ( isPlayer( player ) && !level.oldschool && ( level.disableClassSelection != 1 ) && isdefined(player.killstreak) )
	{
		currentKillstreak = 0;
		for ( killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++ )
		{
				if ( isdefined( player.killstreak[ killstreakNum ] ) )
				{
					killstreak[ currentKillstreak ] = player.killstreak[ killstreakNum ];
					currentKillstreak++;
				}
		}
	}
	
	return killstreak;
}

function updateRankedMatch(winner)
{
	if ( level.rankedMatch )
	{
		if ( hostIdledOut() )
		{
			level.hostForcedEnd = true;
			/#print( "host idled out" );#/
			endLobby();
		}
	}
	if ( !level.wagerMatch && !SessionModeIsZombiesGame() )
	{
		globallogic_score::updateMatchBonusScores( winner );
	}
}

