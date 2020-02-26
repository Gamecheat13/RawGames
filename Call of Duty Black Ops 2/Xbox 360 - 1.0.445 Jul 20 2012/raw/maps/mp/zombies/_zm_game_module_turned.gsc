#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_turned;

/*
	Turned ( Encounters )
	Objective: 	Out match the enemy team
	Map ends:	When all players on a team die ( Zombified )
	Respawning:	Respawn as a Zombie if you die, Respawn as a human if you kill a Zombified player
*/

//	******************************************************************************************************
//	REGISTER THE TURNED MODULE
//	******************************************************************************************************
register_game_module()
{
	level.GAME_MODULE_TURNED_INDEX = 6;
	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_TURNED_INDEX, "zturned", ::onPreInitGameType, ::onPostInitGameType, undefined, maps\mp\zombies\_zm_game_module_cleansed::onSpawnZombie, maps\mp\zombies\_zm_game_module_cleansed::onStartGameType );
}

register_turned_match(start_func,end_func,name)
{

	if ( !IsDefined( level._registered_turned_matches ) )
	{
		level._registered_turned_matches = [];
	}

	match = spawnstruct();
	//race.race_start_trig = race_start_trig;
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	level._registered_turned_matches[ level._registered_turned_matches.size ] = match;
}

get_registered_turned_match(name)
{
	foreach ( struct in level._registered_turned_matches )
	{
		if ( struct.match_name == name )
		{
			return struct;
		}
	}
}

set_current_turned_match(name)
{
	level._current_turned_match = name;
}

get_current_turned_match()
{
	return level._current_turned_match;
}


init_zombie_weapon()
{
	maps\mp\zombies\_zm_turned::init();

}


//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

onPrecacheGameType()
{
	precacheshader("faction_cdc");
	precacheshader("faction_cia");
}

onPreInitGameType()
{
}

onPostInitGameType()
{
	if ( level.scr_zm_game_module != level.GAME_MODULE_TURNED_INDEX )
	{
		return;
	}
	level thread init_zombie_weapon();	
}