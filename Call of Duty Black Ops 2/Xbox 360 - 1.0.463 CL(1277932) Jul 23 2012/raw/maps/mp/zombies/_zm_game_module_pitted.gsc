#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

/*
	Pitted ( Encounters )
	Objective:	Survive in endless waves of multiple enemy types
	Map ends: When a team ( Encounters ) is left alive
	Respawning:	Players remain dead for the game mode
*/

//	******************************************************************************************************
//	REGISTER THE PITTED MODULE
//	******************************************************************************************************

register_game_module()
{
	level.GAME_MODULE_PITTED_INDEX = 7;
	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_PITTED_INDEX, "zpitted", ::onPreInitGameType, ::onPostInitGameType, undefined, maps\mp\zombies\_zm_game_module_nml::onSpawnZombie, maps\mp\zombies\_zm_game_module_nml::onStartGameType );
}

register_pitted_match( start_func, end_func, name, pitted_spawn_func, location )
{
	// Running Pitted Through NML
	//---------------------------
	
	if ( !IsDefined( level._registered_nml_matches ) )
	{
		level._registered_nml_matches = [];
	}

	match = SpawnStruct();
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	match.match_spawn_func = pitted_spawn_func;
	match.match_location = location;
	match.mode_name = "zpitted";
	level._registered_nml_matches[ level._registered_nml_matches.size ] = match;
}

//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

onPrecacheGameType()
{
}

onPreInitGameType()
{
}

onPostInitGameType()
{
	if ( level.scr_zm_game_module != level.GAME_MODULE_PITTED_INDEX )
	{
		return;
	}
}