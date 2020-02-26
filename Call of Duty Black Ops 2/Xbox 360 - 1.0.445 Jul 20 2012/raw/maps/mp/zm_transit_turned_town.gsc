#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

onStartGameType()
{
	getSpawnPoints();

	maps\mp\zombies\_zm_game_module_standard::setup_standard_objects( "town" );
	
	//setup all the classic mode stuff 
	maps\mp\zm_transit::setup_classic_gametype();

	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "zcleansed" )
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_CLEANSED_INDEX );
	}
	// Encounters
	//-----------
	else
	{
		maps\mp\zombies\_zm_game_module::set_current_game_module( level.GAME_MODULE_TURNED_INDEX );
	}
	
	// Spawn Collision
	//----------------
	collision = Spawn( "script_model", ( 1363, 471, 0 ), 1 );
	collision SetModel( "zm_collision_transit_town_survival" );
	collision DisconnectPaths();
}

getSpawnPoints()
{
	level._turned_zombie_spawners = GetEntArray( "game_mode_spawners", "targetname" );

	level._turned_zombie_spawnpoints = getstructarray("town_turned_zombie_spawn","targetname");
}

onEndGame()
{

}


clear_meat_world_objects()
{

	ents = getentarray("meat_town_barriers","targetname");
	for(i=0;i<ents.size;i++)
	{
		if(isDefined(ents[i].spawnflags) && ents[i].spawnflags == 1)
		{
			ents[i] connectpaths();
		}
		ents[i] trigger_off();
	}

	ents = getentarray("meat_barriers","targetname");
	for(i=0;i<ents.size;i++)
	{
		if(isDefined(ents[i].spawnflags) && ents[i].spawnflags == 1)
		{
			ents[i] connectpaths();
		}
		ents[i] trigger_off();
	}

	barricade_ents = getentarray("race_meat_barricade","targetname");
	for(i=0;i<barricade_ents.size;i++)
	{
		if(isDefined(barricade_ents[i].spawnflags) && barricade_ents[i].spawnflags == 1)
		{
			barricade_ents[i] connectpaths();
		}
		barricade_ents[i] trigger_off();
	}
	if(isDefined(level._meat_barricades))
	{
		for(i=0;i<level._meat_barricades.size;i++)
		{
			if(!isDefined(level._meat_barricades[i]))
			{
				continue;
			}
			level._meat_barricades[i] delete();
		}
	}

	//	traversal_nodes = getnodearray("meat_town_barrier_traversals","targetname");
	//	for(i=0;i<traversal_nodes.size;i++)
	//	{
	//		end_node = getnode(traversal_nodes[i].target,"targetname");
	//		UnLinkNodes(traversal_nodes[i],end_node);
	//		//SetEnableNode(traversal_nodes[i],false);
	//		wait(.05);
	//	}
	//
	//	ents = getentarray("meat_town_barriers","targetname");
	//	for(i=0;i<ents.size;i++)
	//	{
	//		if(isDefined(ents[i].spawnflags) && ents[i].spawnflags == 1)
	//		{
	//			ents[i] connectpaths();
	//		}
	//		ents[i] trigger_off();
	//	}


}

clear_race_world_objects()
{
	race_barriers = getentarray("race_barriers","targetname");
	for(i=0;i<race_barriers.size;i++)
	{
		if(isDefined(race_barriers[i].spawnflags) && race_barriers[i].spawnflags == 1)
		{
			race_barriers[i] connectpaths();
		}
		race_barriers[i] delete();
	}

	finish_lines = getentarray("race_finishline","targetname");
	for(i=0;i<finish_lines.size;i++)
	{
		finish_lines[i] delete();
	}

	if(isDefined(level._race_barricades))
	{
		for(i=0;i<level._race_barricades.size;i++)
		{
			if(!isDefined(level._race_barricades[i]))
			{
				continue;
			}
			level._race_barricades[i] delete();
		}
	}
}


open_all_doors()
{

	//turn off all door buys
	door_trigs = getentarray("zombie_door","targetname");
	for(i=0;i<door_trigs.size;i++)
	{
		door_trigs[i] trigger_off();
		doors = getentarray(door_trigs[i].target,"targetname");
		for(i=0;i<doors.size;i++)
		{
			doors[i] trigger_off();
		}
	}
}

setup_turned_world_objects()
{

	// hide all the objects associated with turned for this map
	all_sbm = getentarray();
	for(i=0;i<all_sbm.size;i++)
	{
		if(!isDefined(all_sbm[i].script_parameters) )
		{
			continue;
		}
		parameters = strtok(all_sbm[i].script_parameters," ");
		for(x=0;x<parameters.size;x++)
		{
			if(parameters[x] != "turned_remove")
			{
				continue;
			}
			if(isDefined(all_sbm[i].spawnflags) && all_sbm[i].spawnflags == 1 )
			{
				all_sbm[i] connectpaths();
			}
			all_sbm[i] delete();
			wait(.05);
		}
	}

	barriers = getentarray("turned_barriers","targetname");
	for(i=0;i<barriers.size;i++)
	{
		barriers[i] movez(-512,.05);
		barriers[i] waittill("movedone");

		if(isDefined(barriers[i].spawnflags) && barriers[i].spawnflags == 1)
		{
			barriers[i] connectpaths();
		}
	}

}