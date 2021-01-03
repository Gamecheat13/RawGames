#using scripts\codescripts\struct;

#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_zm_stats;

/*
	ZCLASSIC - ZClassic Mode, wave based gameplay
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

	zm_gametype::post_gametype_main("zclassic");
}

function onPrecacheGameType()
{
	level.playerSuicideAllowed = true;
	level.canPlayerSuicide =&zm_gametype::canPlayerSuicide;

	zm_gametype::runGameTypePrecache("zclassic");
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

	zm_gametype::runGameTypeMain("zclassic",  &zm_gametype::zclassic_main);
}



