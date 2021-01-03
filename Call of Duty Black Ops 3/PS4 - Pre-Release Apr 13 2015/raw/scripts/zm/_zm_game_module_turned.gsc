#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_turned;

#namespace zm_game_module_turned;

/*
	Turned ( Encounters )
	Objective: 	Out match the enemy team
	Map ends:	When all players on a team die ( Zombified )
	Respawning:	Respawn as a Zombie if you die, Respawn as a human if you kill a Zombified player
*/

//	******************************************************************************************************
//	REGISTER THE TURNED MODULE
//	******************************************************************************************************
function register_game_module()
{
	level.GAME_MODULE_TURNED_INDEX = 6;
	//zm_game_module::register_game_module( level.GAME_MODULE_TURNED_INDEX, "zturned", &zm_game_module_cleansed::onPreInitGameType,&onPostInitGameType, undefined, &zm_game_module_cleansed::onSpawnZombie, &zm_game_module_cleansed::onStartGameType );
}

function register_turned_match(start_func,end_func,name)
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

function get_registered_turned_match(name)
{
	foreach ( struct in level._registered_turned_matches )
	{
		if ( struct.match_name == name )
		{
			return struct;
		}
	}
}

function set_current_turned_match(name)
{
	level._current_turned_match = name;
}

function get_current_turned_match()
{
	return level._current_turned_match;
}


function init_zombie_weapon()
{
	zm_turned::init();
}


//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

function onPostInitGameType()
{
	if ( level.scr_zm_game_module != level.GAME_MODULE_TURNED_INDEX )
	{
		return;
	}
	level thread init_zombie_weapon();	
}
