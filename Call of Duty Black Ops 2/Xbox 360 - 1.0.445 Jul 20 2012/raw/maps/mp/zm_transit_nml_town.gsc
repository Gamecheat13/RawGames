#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

onStartGameType()
{
	level.NML_ZONE_NAME = "zone_tow";

	getSpawnPoints();
	
	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects( "town" );

	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "znml" )
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_NML_INDEX );
	}
	// Encounters
	//-----------
	else
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_PITTED_INDEX );
	}

	set_zombie_var( "zombie_intermission_time", 2 );
	set_zombie_var( "zombie_between_round_time", 2 );

	// Spawn Collision
	//----------------
	collision = Spawn( "script_model", ( 1363, 471, 0 ), 1 );
	collision SetModel( "zm_collision_transit_town_survival" );
	collision DisconnectPaths();	
	
	//setup all the classic mode stuff 
	maps\mp\zm_transit::setup_classic_gametype();
	
	//hide the magic box
	wait(3.0);
	start_chest = getent("start_chest","script_noteworthy");
	start_chest maps\mp\zombies\_zm_magicbox::hide_chest();

	level notify("juggernog_on");
	wait_network_frame();
	level notify("sleight_on");
	wait_network_frame();
	level notify("Pack_A_Punch_on" );
}

getSpawnPoints()
{
	// Use Turned Spawn Points
	//------------------------
	level.nml_zombie_spawnpoints = getstructarray( "town_turned_zombie_spawn", "targetname" );
}

onEndGame()
{
	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "znml" )
	{
	}
	// Encounters
	//-----------
	else
	{
	}
}
