/********************************************************************************************

MODULE: covernodes

	This module shows the proper use and placement of the various typs of covernodes that should
	be used in production maps.
	
	Running The Map:
		
		*Note - for the best exprience when running the map add '+set ai_shownearestnode 64' to your command line options
						to see the nodes drawn where they appear in game.
		
		Just stand on any trigger platform to see an AI be spawned and run to a specific type of cover.  Notice the node placements
		and the specific animations that get played.
		
	
	How to place cover:
	
		This is a brief description of how to place the general types of cover (check module_covernodes.map for exact placements):
		
		COVER_* - this is used when an AI is behind flat cover that his cover animations look good with.  An AI that is in cover
							will lean against and touch the cover object/surface in front of him.
		
		CONCEALMENT_* - this is used when an AI is behind non-flat cover of a specific height (standing/crouching/prone).  An AI
										that is concealed will not actually touch or lean against the cover object in front of him.
		
		GUARD - this is a node used when there is no cover for the AI, but the AI needs to look active or combat ready.
		
		BALCONY - this should be placed flush against the railing of a balcony, pointing the direction of the fall.
		
		TURRET - this should be placed nearby a turret and connected to the turret.
		
		note: all of the other types of node are for non-cover behaviors.
		
	
	Known Issues: Last Updated 7/27/09
		
		* - cover_right (or left) - when standing at this type of cover the AI will often clip his gun through a wall when targetting 
			another AI.
																	
		* - conceal_prone - animation is garbage when AI throws a grenade from this position.
	

**********************************************************************************************/

#include maps\_utility;
#include maps\feature_utility;
#include common_scripts\utility;

main()
{
	maps\module_covernodes_utility::main(); // this file sets up all text displays for the module. since this is mainly to show anims, there's no 
											// other scripting here.
}

// this function allows balcony deaths to play continuously on each node for reference purposes.
balcony_nodes(guys)
{
	for (i = 0; i < guys.size; i++)
	{
		if (IsAlive(guys[i]))
		{
			node = GetNode(guys[i].target, "targetname");  // each spawner is targeting a node with 'balcony' enabled in Radiant
			node thread maps\module_covernodes_utility::print_node_type(guys[i]);

			// force balcony deaths by resetting the count to 0
			node.balconyDeathCounter = 0;
		}
	}

	maps\module_covernodes_utility::goto_cover(guys);
}