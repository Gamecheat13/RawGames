    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_persistence;

#using scripts\cp\_popups;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;

#namespace persistence;

function autoexec __init__sytem__() {     system::register("persistence",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
}

function init()
{
	level.persistentDataInfo = [];
	level.maxRecentStats = 10;
	level.maxHitLocations = 19;
	loadout::init();
	//level thread _properks::init();
	_popups::init();
	
	level thread initialize_stat_tracking();
	level thread upload_global_stat_counters();	
}


function on_player_connect()
{
	self.enableText = true;
}

function initialize_stat_tracking()
{
	level.globalExecutions = 0;
	level.globalChallenges = 0;
	level.globalSharePackages = 0;
	level.globalContractsFailed = 0;
	level.globalContractsPassed = 0;
	level.globalContractsCPPaid = 0;
	level.globalKillstreaksCalled = 0;
	level.globalKillstreaksDestroyed = 0;
	level.globalKillstreaksDeathsFrom = 0;
	level.globalLarrysKilled = 0;
	level.globalBuzzKills = 0;
	level.globalRevives = 0;
	level.globalAfterlifes = 0;
	level.globalComebacks = 0;
	level.globalPaybacks = 0;
	level.globalBackstabs = 0;
	level.globalBankshots = 0;
	level.globalSkewered = 0;
	level.globalTeamMedals = 0;
	level.globalFeetFallen = 0;
	level.globalDistanceSprinted = 0;
	level.globalDemBombsProtected = 0;
	level.globalDemBombsDestroyed = 0;
	level.globalBombsDestroyed = 0;
	level.globalFragGrenadesFired = 0;
	level.globalSatchelChargeFired = 0;
	level.globalShotsFired = 0;
	level.globalCrossbowFired = 0;
	level.globalCarsDestroyed = 0;
	level.globalBarrelsDestroyed = 0;

	level.globalBombsDestroyedByTeam = [];
	
	foreach( team in level.teams )
	{
		level.globalBombsDestroyedByTeam[team] = 0;
	}
}

function upload_global_stat_counters()
{
	level waittill("game_ended");
	
	if ( !level.rankedMatch && !level.wagerMatch  ) 
		return;
		
	totalKills = 0;
	totalDeaths = 0;
	totalAssists = 0;
	totalHeadshots = 0;
	totalSuicides = 0;
	totalTimePlayed = 0;
	totalFlagsCaptured = 0;
	totalFlagsReturned = 0;
	totalHQsDestroyed = 0;
	totalHQsCaptured = 0;
	totalSDDefused = 0;
	totalSDPlants = 0;
	totalHumiliations = 0;	
	
	totalSabDestroyedByTeam = [];
	foreach ( team in level.teams )
	{
		totalSabDestroyedByTeam[team] = 0;
	}
	
	switch ( level.gameType )
	{
		case "dem":
		{
			bombZonesLeft = 0;
	
			for ( index = 0; index < level.bombZones.size; index++ )
			{
				if ( !isdefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
					level.globalDemBombsProtected++;
				else
					level.globalDemBombsDestroyed++;
			}
		}
		break;
		case "sab":
		{
			foreach ( team in level.teams )
			{
				totalSabDestroyedByTeam[team] = level.globalBombsDestroyedByTeam[team];
			}
		}
		break;		
	}

	players = GetPlayers();
	for( i = 0; i < players.size; i++)
	{
		player = players[i];
		totalTimePlayed += min( player.timePlayed["total"], level.timeplayedcap );
	}
		
	incrementCounter( "global_executions", level.globalExecutions );
	incrementCounter( "global_sharedpackagemedals", level.globalSharePackages );
	incrementCounter( "global_dem_bombsdestroyed", level.globalDemBombsDestroyed );
	incrementCounter( "global_dem_bombsprotected", level.globalDemBombsProtected );
	incrementCounter( "global_contracts_failed", level.globalContractsFailed );
	incrementCounter( "global_killstreaks_called", level.globalKillstreaksCalled );
	incrementCounter( "global_killstreaks_destroyed", level.globalKillstreaksDestroyed );
	incrementCounter( "global_killstreaks_deathsfrom", level.globalKillstreaksDeathsFrom );
	incrementCounter( "global_buzzkills", level.globalBuzzKills );
	incrementCounter( "global_revives", level.globalRevives );
	incrementCounter( "global_afterlifes", level.globalAfterlifes );
	incrementCounter( "global_comebacks", level.globalComebacks );
	incrementCounter( "global_paybacks", level.globalPaybacks );
	incrementCounter( "global_backstabs", level.globalBackstabs );
	incrementCounter( "global_bankshots", level.globalBankshots );
	incrementCounter( "global_skewered", level.globalSkewered );
	incrementCounter( "global_teammedals", level.globalTeamMedals );
	incrementCounter( "global_fraggrenadesthrown", level.globalFragGrenadesFired );
	incrementCounter( "global_c4thrown", level.globalSatchelChargeFired );
	incrementCounter( "global_shotsfired", level.globalShotsFired );
	incrementCounter( "global_crossbowfired", level.globalCrossbowFired );
	incrementCounter( "global_carsdestroyed", level.globalCarsDestroyed );
	incrementCounter( "global_barrelsdestroyed", level.globalBarrelsDestroyed );
	incrementCounter( "global_challenges_finished", level.globalChallenges );
	incrementCounter( "global_contractscppaid", level.globalContractsCPPaid );
	incrementCounter( "global_distancesprinted100inches", int( level.globalDistanceSprinted ) );	
	incrementCounter( "global_distancefeetfallen", int( level.globalFeetFallen ) );	
	incrementCounter( "global_minutes", int( totalTimePlayed / 60 ) );

	if ( !util::wasLastRound() )
		return;

	{wait(.05);};
	
	players = GetPlayers();
	for( i = 0; i < players.size; i++)
	{
		player = players[i];
		totalKills += player.kills;
		totalDeaths += player.deaths;
		totalAssists += player.assists;
		totalHeadshots += player.headshots;	
		totalSuicides += player.suicides;
		totalHumiliations += player.humiliated;
		totalTimePlayed += int( min( player.timePlayed["alive"], level.timeplayedcap ) );
		
		switch ( level.gameType )
		{
			case "ctf":
			{
				totalFlagsCaptured += player.captures;
				totalFlagsReturned += player.returns;
			}
			break;
			case "koth":
			{
				totalHQsDestroyed += player.destructions;
				totalHQsCaptured += player.captures;
			}
			break;
			case "sd":
			{
				totalSDDefused += player.defuses;
				totalSDPlants += player.plants;		
			}
			break;
			case "sab":
			{
				if ( isdefined(player.team) && isdefined( level.teams[ player.team ] ) )
				{
					totalSabDestroyedByTeam[player.team] += player.destructions;
				}
			}
			break;
		}
	}
	
	incrementCounter( "global_kills", totalKills );
	incrementCounter( "global_deaths", totalDeaths );
	incrementCounter( "global_assists", totalAssists );
	incrementCounter( "global_headshots", totalHeadshots );
	incrementCounter( "global_suicides", totalSuicides );
	incrementCounter( "global_games", 1 );
	incrementCounter( "global_ctf_flagscaptured", totalFlagsCaptured );
	incrementCounter( "global_ctf_flagsreturned", totalFlagsReturned );
	incrementCounter( "global_hq_destroyed", totalHQsDestroyed );
	incrementCounter( "global_hq_captured", totalHQsCaptured );
	incrementCounter( "global_snd_defuses", totalSDDefused );
	incrementCounter( "global_snd_plants", totalSDPlants );
	// TODO MTEAM - Need to update counters if we ever add a third team to sab
	incrementCounter( "global_sab_destroyedbyops", totalSabDestroyedByTeam["allies"] );
	incrementCounter( "global_sab_destroyedbycommunists", totalSabDestroyedByTeam["axis"] );
	incrementCounter( "global_humiliations", totalHumiliations );	
	if ( isdefined( game["wager_pot"] ) )
	{
		incrementCounter( "global_wageredcp", game["wager_pot"] );	
	}
}

// ==========================================
// Script persistent data functions
// These are made for convenience, so persistent data can be tracked by strings.
// They make use of code functions which are prototyped below.

function stat_get_with_gametype( dataName )
{
	if( isdefined( level.noPersistence ) && level.noPersistence )
		return 0;
		
	if ( !level.onlineGame )
		return 0;
		
	return ( self getdstat( "PlayerStatsByGameType", get_gametype_name(), dataName, "StatValue" ) );
}

function get_gametype_name()
{
	if ( !isdefined( level.fullGameTypeName ) )
	{
		if ( isdefined( level.hardcoreMode ) && level.hardcoreMode && is_party_gamemode() == false )
		{
			prefix = "HC";
		}
		else
		{
			prefix = "";
		}
		
		level.fullGameTypeName = toLower( prefix + level.gametype );
	}
	
	return level.fullGameTypeName;
	
}

function is_party_gamemode()
{
	switch( level.gametype )
	{
		case "gun":
		case "oic":
		case "shrp":
		case "sas":
			return true;
			break;
			
	}
	return false;
}

function is_stat_modifiable( dataName )
{
	return level.rankedMatch || level.wagerMatch;
}

function can_set_aar_stat()
{
	if( SessionModeIsCampaignGame() )
	{
		return true;
	}
	
	if( level.rankedMatch )
	{
		return true;
	}
	
	return false;
}

function stat_set_with_gametype( dataName, value, incValue )
{
	if( isdefined( level.noPersistence ) && level.noPersistence )
		return 0;

	if ( !is_stat_modifiable( dataName ) )
		return;
		
	if ( level.disableStatTracking )
	{
		return;
	}
		
	self setdstat( "PlayerStatsByGameType", get_gametype_name(), dataName, "StatValue", value );
}

function adjust_recent_stats()
{
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/

	initialize_match_stats();
}

function get_recent_stat( isGlobal, index, statName )
{
	if( level.wagerMatch )
	{
		return self getdstat( "RecentEarnings", index, statName );
	}
	else if( isGlobal )
	{
		modeName = globallogic::GetCurrentGameMode();
		return self getdstat( "gameHistory", modeName, "matchHistory", index, statName );
	}
	else 
	{
		return self getdstat( "PlayerStatsByGameType", get_gametype_name(), "prevScores" , index, statName );
	}
}

function set_recent_stat( isGlobal, index, statName, value )
{
	if( isdefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !is_stat_modifiable( statName ) )
		return;

	if( index < 0 || index > 9 )
		return;

	if( level.wagerMatch )
	{
		self setdstat( "RecentEarnings", index, statName, value );
	}
	else if( isGlobal )
	{
		modeName = globallogic::GetCurrentGameMode();
		self setdstat( "gameHistory", modeName, "matchHistory", "" + index, statName, value );
		return;
	}
	else 
	{
		self setdstat( "PlayerStatsByGameType", get_gametype_name(), "prevScores" , index, statName, value );
		return;
	}
}

function add_recent_stat( isGlobal, index, statName, value )
{
	if( isdefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !is_stat_modifiable( statName ) )
		return;

	currStat = get_recent_stat( isGlobal, index, statName );
	set_recent_stat( isGlobal, index, statName, currStat + value );
}

function set_match_history_stat( statName, value )
{
	modeName = globallogic::GetCurrentGameMode();
	historyIndex = self GetDStat( "gameHistory", modeName, "currentMatchHistoryIndex" );

	set_recent_stat( true, historyIndex, statName, value );
}

function add_match_history_stat( statName, value )
{
	modeName = globallogic::GetCurrentGameMode();
	historyIndex = self GetDStat( "gameHistory", modeName, "currentMatchHistoryIndex" );

	add_recent_stat( true, historyIndex, statName, value );
}

function initialize_match_stats()
{
	if( isdefined( level.noPersistence ) && level.noPersistence )
		return;
		
	if ( !level.onlineGame )
		return;

	if ( !( level.rankedMatch || level.wagerMatch || level.leagueMatch ) )	
		return; 

	self.pers["lastHighestScore"] =  self getDStat( "HighestStats", "highest_score" );

	currGameType = persistence::get_gametype_name();
	self GameHistoryStartMatch( getGameTypeEnumFromName( currGameType, level.hardcoreMode ) );
}

function set_after_action_report_player_stat( playerIndex, statName, value )
{
	if ( can_set_aar_stat() )
	{
		self setdstat( "AfterActionReportStats", "playerStats", playerIndex, statName, value );
	}
}

function set_after_action_report_player_medal( playerIndex, medalIndex, value )
{
	if ( can_set_aar_stat() )
	{
		self setdstat( "AfterActionReportStats", "playerStats", playerIndex, "medals", medalIndex, value );
	}
}

function set_after_action_report_stat( statName, value, index )
{
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/
	
	if ( can_set_aar_stat() )
	{
		if ( isdefined( index ) )
			self setdstat( "AfterActionReportStats", statName, index, value );
		else
			self setdstat( "AfterActionReportStats", statName, value );
	}
}

function CodeCallback_ChallengeComplete( rewardXP, maxVal, row, tableNumber, challengeType, itemIndex, challengeIndex )
{
	self LUINotifyEvent( &"challenge_complete", 7, challengeIndex, itemIndex, challengeType, tableNumber, row, maxVal, rewardXP );
	self LUINotifyEventToSpectators( &"challenge_complete", 7, challengeIndex, itemIndex, challengeType, tableNumber, row, maxVal, rewardXP );
}

function CodeCallback_GunChallengeComplete( rewardXP, attachmentIndex, itemIndex, rankID )
{
	self LUINotifyEvent( &"gun_level_complete", 4, rankID, itemIndex, attachmentIndex, rewardXP );
	self LUINotifyEventToSpectators( &"gun_level_complete", 4, rankID, itemIndex, attachmentIndex, rewardXP );
}

function check_contract_expirations()
{
}

function increment_contract_times( timeInc )
{
}

function add_contract_to_queue( index, passed )
{
}

function upload_stats_soon()
{
	self notify( "upload_stats_soon" );
	self endon( "upload_stats_soon" );
	self endon( "disconnect" );

	wait 1;
	UploadStats( self );
}

function CodeCallback_OnAddPlayerStat(dataName, value)
{
}

function CodeCallback_OnAddWeaponStat(weapon, dataName, value)
{
}

function process_contracts_on_add_stat(statType, dataName, value, weapon)
{
}
