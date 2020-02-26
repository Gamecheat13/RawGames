#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

onStartGameType()
{
	cleanUpGamePieces();

	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects( "farm" );
	
	//setup all the classic mode stuff 
	maps\mp\zm_transit::setup_classic_gametype();
	
	maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_GRIEF_INDEX );

	maps\mp\zombies\_zm_game_module::kill_all_zombies();

	// Spawn Collision
	//----------------
	collision = Spawn( "script_model", ( 8000, -5800, 0 ), 1 );
	collision SetModel( "zm_collision_transit_farm_survival" );
	collision DisconnectPaths();
	
	wait(3);
	
	// Set Up Magic Box
	//-----------------
	chest = GetEnt( "farm_chest", "script_noteworthy" );
	chest maps\mp\zombies\_zm_magicbox::show_chest();
	chest maps\mp\zombies\_zm_magicbox::hide_rubble();
	chest.no_fly_away = true;
	level.chests[ level.chest_index ] = chest;

	// Hide Start Chest
	//-----------------
	start_chest = GetEnt( "start_chest", "script_noteworthy" );
	start_chest maps\mp\zombies\_zm_magicbox::hide_chest();

	level thread maps\mp\zombies\_zm_zonemgr::enable_zone( "zone_far_ext" );

	level notify("revive_on");				
	wait_network_frame();
	level notify("doubletap_on");
	wait_network_frame();
	level notify("marathon_on");
	wait_network_frame();
	level notify("juggernog_on");
	wait_network_frame();
	level notify("sleight_on");
	wait_network_frame();
	level notify("Pack_A_Punch_on");				
}

cleanUpGamePieces()
{
//	maps\mp\zm_transit::setup_classic_gametype();
	
	ents = GetEntArray();
	foreach ( ent in ents )
	{
		if ( IsDefined( ent.script_flag ) && ent.script_flag == "OnFarm_enter" )
		{
			ent Delete();
			continue;
		}
		
		if ( IsDefined( ent.script_parameters ) )
		{
			tokens = StrTok( ent.script_parameters, " " );
			remove = false;
			
			foreach ( token in tokens )
			{
				if ( token == "standard_remove" )
				{
					remove = true;
				}
			}
			
			if ( remove )
			{
				ent Delete();
			}
		}
	}
}

onEndGame()
{
}