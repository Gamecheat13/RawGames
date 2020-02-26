#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

onStartGameType()
{
	getSpawnPoints();

	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects( "farm" );

	//setup all the classic mode stuff
	maps\mp\zm_transit::setup_classic_gametype();

	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "zcleansed" )
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_CLEANSED_INDEX );
		
		front_door = GetEntArray( "auto2434", "targetname" );
		array_thread( front_door, ::self_delete );
		
		back_door = GetEntArray( "auto2434", "targetname" );
		array_thread( back_door, ::self_delete );
	}
	// Encounters
	//-----------
	else
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_TURNED_INDEX );
	}

	// Spawn Collision
	//----------------
	collision = Spawn( "script_model", ( 8000, -5800, 0 ), 1 );
	collision SetModel( "zm_collision_transit_farm_survival" );
	collision DisconnectPaths();
}

getSpawnPoints()
{
	level._turned_zombie_spawners = GetEntArray( "game_mode_spawners", "targetname" );

	level._turned_zombie_spawnpoints = getstructarray("town_turned_zombie_spawn","targetname");
	
	level._turned_zombie_respawnpoints = getstructarray( "farm_standard_player_respawns", "targetname" );
	
	level._turned_powerup_spawnpoints = [];
	level._turned_powerup_spawnpoints[ 0 ] = SpawnStruct();
	level._turned_powerup_spawnpoints[ 0 ].origin = ( 8192, -5360, 272 ); // Barn
	level._turned_powerup_spawnpoints[ 1 ] = SpawnStruct();
	level._turned_powerup_spawnpoints[ 1 ].origin = ( 7800, -5752, 11.9375 ); // Exterior Center By Truck
	level._turned_powerup_spawnpoints[ 2 ] = SpawnStruct();
	level._turned_powerup_spawnpoints[ 2 ].origin = ( 8456, -6344, 106.715 ); // Exterior By Garden
	level._turned_powerup_spawnpoints[ 3 ] = SpawnStruct();
	level._turned_powerup_spawnpoints[ 3 ].origin = ( 8104, -6256, 245 ); // Farm House
}

onEndGame()
{

}
