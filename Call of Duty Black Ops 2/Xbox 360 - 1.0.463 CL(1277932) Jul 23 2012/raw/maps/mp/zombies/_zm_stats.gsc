#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 


init()
{

	// create a level function pointer, so that add_client_stat function can be called in non zm script file
	level.player_stats_init = ::player_stats_init;
	level.add_client_stat = ::add_client_stat;
	level.increment_client_stat = ::increment_client_stat;
	
}

player_stats_init()
{

	

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "kills", false );
	self.kills = self  maps\mp\gametypes\_globallogic_score::getPersStat( "kills" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "downs", false );
	self.downs = self  maps\mp\gametypes\_globallogic_score::getPersStat( "downs" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "revives", false );
	self.revives = self  maps\mp\gametypes\_globallogic_score::getPersStat( "revives" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "perks_drank", false );
	self.perks_drank = self  maps\mp\gametypes\_globallogic_score::getPersStat( "perks_drank" );


	self  maps\mp\gametypes\_globallogic_score::initPersStat( "headshots", false );
	self.headshots = self  maps\mp\gametypes\_globallogic_score::getPersStat( "headshots" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "gibs", false );
	self.gibs = self  maps\mp\gametypes\_globallogic_score::getPersStat( "gibs" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "grenade_kills", false );
	self.grenade_kills = self  maps\mp\gametypes\_globallogic_score::getPersStat( "grenade_kills" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "doors_purchased", false );
	self.doors_purchased = self  maps\mp\gametypes\_globallogic_score::getPersStat( "doors_purchased" );


	self  maps\mp\gametypes\_globallogic_score::initPersStat( "distance_traveled", false );
	self.distance_traveled = self  maps\mp\gametypes\_globallogic_score::getPersStat( "distance_traveled" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "total_shots", false );
	self.total_shots = self  maps\mp\gametypes\_globallogic_score::getPersStat( "total_shots" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "hits", false );
	self.hits = self  maps\mp\gametypes\_globallogic_score::getPersStat( "hits" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "deaths", false );
	self.deaths = self  maps\mp\gametypes\_globallogic_score::getPersStat( "deaths" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "boards", false );
	self.boards = self  maps\mp\gametypes\_globallogic_score::getPersStat( "boards" );

	self  maps\mp\gametypes\_globallogic_score::initPersStat( "wins", false );
	self  maps\mp\gametypes\_globallogic_score::initPersStat( "losses", false );

	// some extra ... 
	self  maps\mp\gametypes\_globallogic_score::initPersStat( "score", false );
	if ( level.resetPlayerScoreEveryRound )
	{
		self.pers["score"] = 0;
	}

	self.pers["score"] = 500;
	self.score = self.pers["score"];

	self maps\mp\gametypes\_globallogic_score::initPersStat( "zteam", false );

	// Zombie may need this later
	self maps\mp\gametypes\_globallogic_score::initPersStat( "lossAlreadyReported", false );


	if ( IsDefined( level.level_specific_stats_init ) )
	{
		[[ level.level_specific_stats_init ]]();
	}

	if( !isDefined( self.stats_this_frame ) )
	{
		self.pers_upgrade_force_test = true;
		self.stats_this_frame = [];				// used to track if stats is update in current frame
		self.pers_upgrades_awarded = [];
	}

}

update_players_stats_at_match_end( players )
{
	// update the player stats at the end of match
	game_mode = GetDvar( "ui_gametype" );
	game_mode_group = GetDvar( "ui_zm_gamemodegroup" );
	players_counter_str = "" + ( players.size - 1 );
	map_location_name = level.scr_zm_map_start_location;

	// will be updated based on info from gametypesTable.csv 
	if ( map_location_name == "" )
		map_location_name = "default";
	
	for ( i = 0; i < players.size; i++ ) 
	{	
		player = players[i];
		// 1). distance traveled
		player AddPlayerStatWithGameType( "distance_traveled", player get_stat_distance_traveled() );
		player AddPlayerStatWithGameType( "rounds", player get_stat_round_number() );

		if ( game_mode_group == "zsurvival" || game_mode_group == "zclassic")
		{
			player update_survival_stat( players_counter_str, map_location_name, "rounds", player get_stat_round_number() );
			player update_survival_stat( players_counter_str, map_location_name, "combined_rank", player get_stat_combined_rank_value() );
		}
	}
}

//**************************************************************
//**************************************************************
// DDL stats operation functions

add_game_mode_group_stat( game_mode, stat_name, value )
{
	self AddDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue", value );
}

set_game_mode_group_stat( game_mode, stat_name, value )
{
	self SetDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue", value );
}

get_game_mode_group_stat( game_mode, stat_name)
{
	return ( self GetDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue" ) );
}

//--------------------------------------------------------------
add_game_mode_stat( game_mode, stat_name, value )
{
	self AddDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue", value );
}

set_game_mode_stat( game_mode, stat_name, value )
{
	self SetDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue", value );
}

get_game_mode_stat( game_mode, stat_name)
{
	return ( self GetDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue" ) );
}

//--------------------------------------------------------------
add_survival_stat( players_count, map_location, stat_name, value )
{
	self AddDStat( "PlayerStatsZClassic", players_count, "mapLocationStats", map_location, "stats", stat_name, "statValue", value );
}

get_survival_stat( players_count, map_location, stat_name )
{
	return ( self GetDStat( "PlayerStatsZClassic", players_count, "mapLocationStats", map_location, "stats", stat_name, "statValue" ) );
}

set_survival_stat( players_count, map_location, stat_name, value )
{
	self SetDStat( "PlayerStatsZClassic", players_count, "mapLocationStats", map_location, "stats", stat_name, "statValue", value );
}

update_survival_stat( players_count, map_location, stat_name, value )
{
	if ( self get_survival_stat(players_count, map_location, stat_name) < value )
		self set_survival_stat( players_count, map_location, stat_name, value );
}

//--------------------------------------------------------------
get_global_stat( stat_name )
{
	return ( self GetDStat( "PlayerStatsList", stat_name, "StatValue" ) );
}

set_global_stat( stat_name, value )
{
	self SetDStat( "PlayerStatsList", stat_name, "StatValue", value );
}

add_global_stat( stat_name, value )
{
	self AddDStat( "PlayerStatsList", stat_name, "StatValue", value );
}

//--------------------------------------------------------------
get_map_stat( stat_name )
{
	return ( self GetDStat( "PlayerStatsByMap", level.script, stat_name ) );
}

set_map_stat( stat_name, value )
{
	self SetDStat( "PlayerStatsByMap", level.script, stat_name, value );
}

add_map_stat( stat_name, value )
{
	self AddDStat( "PlayerStatsByMap", level.script, stat_name, value );
}

//--------------------------------------------------------------
get_map_weaponlocker_stat( stat_name )
{
	return ( self GetDStat( "PlayerStatsByMap", level.script, "weaponLocker", stat_name ) );
}

set_map_weaponlocker_stat( stat_name, value )
{
	self SetDStat( "PlayerStatsByMap", level.script, "weaponLocker", stat_name, value );
}

add_map_weaponlocker_stat( stat_name, value )
{
	self AddDStat( "PlayerStatsByMap", level.script, "weaponLocker", stat_name, value );
}

//**************************************************************
//**************************************************************

add_client_stat( stat_name, stat_value )
{
	if ( GetDvar( "ui_zm_mapstartlocation" ) == "" )
		return;

	self maps\mp\gametypes\_globallogic_score::incPersStat( stat_name, stat_value, false, true );	
	self.stats_this_frame[stat_name] = true;
}

increment_client_stat( stat_name )
{
	add_client_stat( stat_name, 1 );
}

//**************************************************************
//**************************************************************

get_stat_distance_traveled()
{
	return int( self.pers["distance_traveled"] / 100 ); // Current distance was too large to capture in inches
}

get_stat_round_number()
{
	return (level.round_number - 1);
}

get_stat_combined_rank_value()
{
	rounds = get_stat_round_number();
	kills = self.pers["kills"];

	if( rounds > 99 ) 
		rounds = 99;

	result = "" + rounds;
	if ( kills < 10 )
		result += "000000";
	else if ( kills < 100 )
		result += "00000";
	else if ( kills < 1000 )
		result += "0000";
	else if ( kills < 10000 )
		result += "000";
	else if ( kills < 100000 )
		result += "00";
	else if ( kills < 1000000 )
		result += "0";
		
	result += kills;
	return int( result );
}

//**************************************************************
//**************************************************************
