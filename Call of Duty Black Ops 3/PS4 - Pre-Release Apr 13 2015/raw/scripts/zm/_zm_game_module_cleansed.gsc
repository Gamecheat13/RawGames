#using scripts\codescripts\struct;

#using scripts\shared\demo_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace zm_game_module_cleansed;

/*
	Cleansed ( Survival )
	Objective: 	Out match the other players on your team
	Map ends:	When only one human player is left standing
	Respawning:	Respawn as a Zombie if you die, Respawn as a human if you kill a Zombified player
*/

//	******************************************************************************************************
//	REGISTER THE CLEANSED MODULE
//	******************************************************************************************************
function register_game_module()
{
//	level.GAME_MODULE_CLEANSED_INDEX = 8;
//	zm_game_module::register_game_module( level.GAME_MODULE_CLEANSED_INDEX, "zcleansed",&onPreInitGameType,&onPostInitGameType, undefined,&onSpawnZombie,&onStartGameType );
}

function onStartGameType( name )
{
	
	//level thread onStartCleansedGameType();

	//* level thread zombieSpawnLogic();

	// Don't Allow Carpenter
	//----------------------

	//* level thread zm::round_start();
}

function onStartCleansedGameType()
{
}
