#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace ability_gadgets;

function autoexec __init__sytem__() {     system::register("ability_gadgets",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect( local_client_num )
{
}

function on_player_spawned( local_client_num )
{
}
