#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

/*
	Grief ( Encounters )
	Objective: 	Out match the players on the other team
	Map ends:	When only one team is standing
	Respawning:	None
*/

//	******************************************************************************************************
//	REGISTER THE GRIEF MODULE
//	******************************************************************************************************
register_game_module()
{
	level.GAME_MODULE_GRIEF_INDEX = 9;
	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_GRIEF_INDEX, "zgrief", ::onPreInitGameType, ::onPostInitGameType, undefined, ::onSpawnZombie, ::onStartGameType );
}

register_grief_match( start_func, end_func,name, precache_func )
{
	if ( !IsDefined( level._registered_grief_matches ) )
	{
		level._registered_grief_matches = [];
	}

	match = SpawnStruct();
	//race.race_start_trig = race_start_trig;
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	match.match_precache_func = precache_func;
	level._registered_grief_matches[ level._registered_grief_matches.size ] = match;
}

get_registered_grief_match( name )
{
	foreach ( struct in level._registered_grief_matches )
	{
		if ( struct.match_name == name )
		{
			return struct;
		}
	}
}

set_current_grief_match( name )
{
	level._current_grief_match = name;
}

get_current_grief_match()
{
	return level._current_grief_match;
}

//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

onPrecacheGameType()
{
	// Encounters
	//-----------
	if ( GetDvar( "ui_gametype" ) == "zgrief" )
	{
		location = GetDvar( "ui_zm_mapstartlocation" );
	}
	precacheshader("faction_cdc");
	precacheshader("faction_cia");
	
}

onPreInitGameType()
{
	if ( GetDvar( "ui_gametype" ) != "zgrief" )
	{
		return;
	}

	level thread onPrecacheGameType();
}

onPostInitGameType()
{
	if ( level.scr_zm_game_module != level.GAME_MODULE_GRIEF_INDEX )
	{
		return;
	}
}

onStartGameType( name )
{
	updateGametypeVariables();

	match = get_registered_grief_match( name );
	set_current_grief_match( name );

	if ( IsDefined( match ) )
	{
		level thread [[ match.match_start_func ]]();
		level thread [[ match.match_end_func ]]();
	}

	onSpawnPlayer();

	IPrintLnBold( "OUT LIVE THE OTHER TEAM" );

	level thread onStartGriefGameType();
	
	level thread maps\mp\zombies\_zm::round_start();
	
	level thread maps\mp\zombies\_zm_game_module::wait_for_team_death();
}

updateGametypeVariables()
{
	level.min_humans = 1;

	level._zombie_spawning = false;
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	level.is_zombie_level=true;
	level.no_board_repair = true; 		//prevent repairing of boards
	set_zombie_var( "zombify_player", 					true );
	
	//flag_set( "door_can_close" );

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

clearGametypeVariables()
{
	level.zombie_health = level.zombie_vars[ "zombie_health_start" ];
	level._zombie_spawning = false;
	level._get_game_module_players = undefined;
	level.zombie_custom_think_logic = undefined;
	level.powerup_drop_count = 0;
	level._grief_zombie_spawners = undefined;
	level.is_zombie_level=false;
	level.player_becomes_zombie		= maps\mp\zombies\_zm::zombify_player;
	set_zombie_var( "zombify_player", 					false );
	SetDvar( "player_lastStandBleedoutTime", "45" );

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

onSpawnPlayer()
{
	players = GET_PLAYERS();
	foreach ( index, player in players )
	{
		player.ignoreme = false;
		player.score = 500;
		player TakeAllWeapons();
		player GiveWeapon( "knife_zm" );
		player give_start_weapon( true );

		player.prevteam = player.team;
		player thread maps\mp\zombies\_zm_game_module::team_icon_intro(player._team_hud["team"]);
	}
}

onSpawnZombie()
{
}

onStartGriefGameType()
{
	level endon( "grief_end" );
	
	flag_set ( "power_on" );

	// Kicks Off The Grief Logic
	//-----------------------------

	level notify( "start_fullscreen_fade_out" );
}