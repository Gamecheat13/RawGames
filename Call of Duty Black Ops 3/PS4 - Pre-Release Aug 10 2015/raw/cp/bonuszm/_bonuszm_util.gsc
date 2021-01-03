#using scripts\codescripts\struct;
#using scripts\shared\ammo_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientids_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\vehicle_shared;

#using scripts\shared\archetype_shared\archetype_shared;

#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\blackboard;

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\_load;
#using scripts\cp\_oed;
#using scripts\cp\_util;

#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm_magicbox;

                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#namespace bonuszmutil;


// -----------------------------------------------------------------
// Get closest node giving an origin and region and radius to search
// -----------------------------------------------------------------
function BZM_FindClosestNodeWithinRegion( origin, region, minRadius, maxRadius )
{
	nodes = GetNodesInRadius( origin, maxRadius, minRadius );
	pathableNodes = [];
	
	foreach( node in nodes )
	{
		if( IsDefined( region ) )
		{
			nodeRegion = GetNodeRegion( node );
			
			if( IsDefined( nodeRegion ) && region == nodeRegion )
			{
				array::add( pathableNodes, node );
			}
		}
		else
		{
			array::add( pathableNodes, node );
		}
	}
	
	goToNode = array::random( pathableNodes );
	
	return goToNode;
}


// -----------------------------------------------------------------
// Get health based on the difficulty
// -----------------------------------------------------------------
function BZM_GetModifiedHealthForDifficulty( health )
{
	assert( IsDefined( health ) );
	scalar = 1;
	
	if( IsDefined( level.currentDifficulty ) )
	{
		switch (level.gameSkill)
		{			
			case 0:
				scalar = level.bonusZMSkiptoData["zombiehealthscale1"];		
				break; // easy
			case 1:
				scalar = level.bonusZMSkiptoData["zombiehealthscale2"];
				break; // normal/regular
			case 2:
				scalar = level.bonusZMSkiptoData["zombiehealthscale3"];
				break; // hardened
			case 3:
				scalar = level.bonusZMSkiptoData["zombiehealthscale4"];
				break; // veteran
			case 4:
				scalar = level.bonusZMSkiptoData["zombiehealthscale5"];
				break; // realistic
		}
	}
	
	return Int( health * scalar );
}


// -----------------------------------------------------------------
// Get modifed number of extra zombies based on the number of players currently present in the level
// -----------------------------------------------------------------
function BZM_GetModifiedMaxExtraZombies()
{	
	scalar = 1;
	
	if( IsDefined( level.currentDifficulty ) )
	{
		switch (level.activePlayers.size)
		{			
			case 1:
				scalar = level.bonusZMSkiptoData["extrazombiescale1"];
				break;
			case 2:
				scalar = level.bonusZMSkiptoData["extrazombiescale2"];
				break;
			case 3:
				scalar = level.bonusZMSkiptoData["extrazombiescale3"];
				break;
			case 4:
				scalar = level.bonusZMSkiptoData["extrazombiescale4"];
				break;
		}
	}
	
	assert( IsDefined( level.bonusZMSkiptoData["extraspawns"] ) );
	
	return Int( level.bonusZMSkiptoData["extraspawns"] * scalar );
}