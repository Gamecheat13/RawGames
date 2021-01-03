#using scripts\codescripts\struct;

#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_stats;

/*
	zstandard - zstandard Mode, wave based gameplay
	Objective: 	Stay alive for as long as you can
	Map ends:	When all players die
	Respawning:	No wait / Near teammates
*/

function main()
{
	zm_gametype::main();	// Generic zombie mode setup - must be called first.
	
	// Mode specific over-rides.
	
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;	
	level._game_module_custom_spawn_init_func = &zm_gametype::custom_spawn_init_func;
	level._game_module_stat_update_func = &zm_stats::survival_classic_custom_stat_update;

	zm_gametype::post_gametype_main("zstandard");
}

function onPrecacheGameType()
{
	level.playerSuicideAllowed = true;
	level.canPlayerSuicide =&zm_gametype::canPlayerSuicide;

	zm_gametype::runGameTypePrecache("zstandard");
}

function onStartGameType()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins( level.spawnMins, struct.origin );
		level.spawnMaxs = math::expand_maxs( level.spawnMaxs, struct.origin );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs ); 
	setMapCenter( level.mapCenter );

	//setup all the classic mode stuff 
	zm_gametype::setup_classic_gametype();
	zm_gametype::runGameTypeMain("zstandard",&zstandard_main);
}

function zstandard_main()
{
	level.dog_rounds_allowed = GetGametypeSetting( "allowdogs" );
	if( level.dog_rounds_allowed )
	{
		zm_ai_dogs::enable_dog_rounds();
	}
	level thread zm::round_start();
	level thread zm_gametype::kill_all_zombies();
}
